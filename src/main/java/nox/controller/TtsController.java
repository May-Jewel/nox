package nox.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import nox.service.ActivityLogger;

@RestController
@RequestMapping("/api/tts")
public class TtsController {

    private static final String GOOGLE_TTS_BASE = "https://translate.google.com/translate_tts";
    private static final int MAX_CHUNK_CHARS = 200;

    @PostMapping
    public void postTts(@RequestParam("text") String text,
                        @RequestParam(value = "lang", defaultValue = "my") String lang,
                        @RequestParam(value = "rate", defaultValue = "1.0") float rate,
                        jakarta.servlet.http.HttpServletResponse response,
                        HttpSession session) throws IOException {

        if (text == null || text.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Text is required");
            return;
        }

        try {
            streamTtsAudio(text, lang, response);

            String metadata = String.format(
                "{\"voiceId\": \"google-tts\", \"speed\": %.1f, \"lang\": \"%s\", \"format\": \"mp3\", \"charCount\": %d}",
                rate, lang, text.length()
            );
            ActivityLogger.log(session, ActivityLogger.TYPE_TTS, "Text to Speech", text, "AUDIO_GENERATED", metadata);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @GetMapping
    public void getTts(@RequestParam("text") String text,
                       @RequestParam(value = "lang", defaultValue = "my") String lang,
                       @RequestParam(value = "tl", required = false) String tl,
                       jakarta.servlet.http.HttpServletResponse response) throws IOException {

        if (lang == null || lang.trim().isEmpty()) {
            lang = tl != null ? tl : "my";
        }

        if (text == null || text.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Text parameter required");
            return;
        }

        try {
            streamTtsAudio(text, lang, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @GetMapping("/download")
    public void downloadFullAudio(@RequestParam("text") String text,
                                  @RequestParam(value = "lang", defaultValue = "my") String lang,
                                  @RequestParam(value = "filename", required = false) String filename,
                                  jakarta.servlet.http.HttpServletResponse response) throws IOException {

        if (text == null || text.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Text parameter required");
            return;
        }

        if (filename == null || filename.trim().isEmpty()) {
            filename = "tts-audio.mp3";
        }

        try {
            byte[] fullAudio = fetchAndCombineAudioChunks(text.trim(), lang);
            
            response.setContentType("audio/mpeg");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
            response.setHeader("Content-Length", String.valueOf(fullAudio.length));
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");

            try (OutputStream out = response.getOutputStream()) {
                out.write(fullAudio);
                out.flush();
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate audio: " + e.getMessage());
            }
        }
    }

    private byte[] fetchAndCombineAudioChunks(String text, String lang) throws IOException {
        List<String> chunks = splitTextIntoChunks(text, MAX_CHUNK_CHARS);
        ByteArrayOutputStream combined = new ByteArrayOutputStream();

        for (String chunk : chunks) {
            byte[] audioBytes = fetchSingleChunkAudio(chunk, lang);
            combined.write(audioBytes);
        }

        return combined.toByteArray();
    }

    private List<String> splitTextIntoChunks(String text, int maxChars) {
        List<String> chunks = new ArrayList<>();
        String cleanText = text.replaceAll("[\\r\\n]+", " ").trim();

        Pattern sentencePattern = Pattern.compile("[^.!?。！？။၊]+[.!?。！？။၊]*");
        Matcher matcher = sentencePattern.matcher(cleanText);

        StringBuilder currentChunk = new StringBuilder();

        while (matcher.find()) {
            String sentence = matcher.group().trim();
            if (sentence.isEmpty()) continue;

            if (currentChunk.length() + sentence.length() + 1 > maxChars && currentChunk.length() > 0) {
                chunks.add(currentChunk.toString().trim());
                currentChunk.setLength(0);
            }

            if (currentChunk.length() > 0) {
                currentChunk.append(' ');
            }
            currentChunk.append(sentence);
        }

        if (currentChunk.length() > 0) {
            chunks.add(currentChunk.toString().trim());
        }

        if (chunks.isEmpty()) {
            for (int i = 0; i < cleanText.length(); i += maxChars) {
                int end = Math.min(i + maxChars, cleanText.length());
                chunks.add(cleanText.substring(i, end).trim());
            }
        }

        return chunks;
    }

    private byte[] fetchSingleChunkAudio(String text, String lang) throws IOException {
        String googleTtsUrl = String.format(
            "%s?ie=UTF-8&q=%s&tl=%s&client=tw-ob",
            GOOGLE_TTS_BASE,
            URLEncoder.encode(text, StandardCharsets.UTF_8),
            URLEncoder.encode(lang, StandardCharsets.UTF_8)
        );

        URL url = new URL(googleTtsUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");
        conn.setRequestProperty("Referer", "https://translate.google.com/");
        conn.setConnectTimeout(10000);
        conn.setReadTimeout(30000);

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            try (InputStream in = conn.getInputStream();
                 ByteArrayOutputStream out = new ByteArrayOutputStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                return out.toByteArray();
            }
        } else {
            throw new IOException("Google TTS returned status: " + responseCode);
        }
    }

    private void streamTtsAudio(String text, String lang, jakarta.servlet.http.HttpServletResponse response) throws IOException {
        String googleTtsUrl = String.format(
            "%s?ie=UTF-8&q=%s&tl=%s&client=tw-ob",
            GOOGLE_TTS_BASE,
            URLEncoder.encode(text, StandardCharsets.UTF_8),
            URLEncoder.encode(lang, StandardCharsets.UTF_8)
        );

        URL url = new URL(googleTtsUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");
        conn.setRequestProperty("Referer", "https://translate.google.com/");

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            response.setContentType("audio/mpeg");
            response.setHeader("Accept-Ranges", "bytes");
            response.setHeader("Cache-Control", "public, max-age=3600");

            try (InputStream in = conn.getInputStream();
                 OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                out.flush();
            }
        } else {
            response.sendError(responseCode, "Failed to stream audio from Google TTS");
        }
    }
}
