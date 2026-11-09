package nox.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;
import nox.service.ActivityLogger;

@RestController
@RequestMapping("/api/translate")
public class TranslateController {

    private static final int MAX_CHUNK_SIZE = 450;

    @PostMapping
    public Map<String, Object> translate(@RequestParam("text") String textToTranslate,
                                         @RequestParam(value = "lang", defaultValue = "my") String targetLang,
                                         HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        if (textToTranslate == null || textToTranslate.trim().isEmpty()) {
            result.put("error", "Text parameter is required.");
            return result;
        }

        try {
            List<String> chunks = splitTextIntoChunks(textToTranslate, MAX_CHUNK_SIZE);
            StringBuilder fullTranslation = new StringBuilder();

            for (String chunk : chunks) {
                String translatedChunk = translateChunk(chunk, targetLang);
                fullTranslation.append(translatedChunk).append(" ");
            }

            String finalResult = fullTranslation.toString().trim();

            String metadata = "{\"targetLang\": \"" + escapeJson(targetLang) + "\"}";
            ActivityLogger.log(session, ActivityLogger.TYPE_TRANSLATE, "Translation Task",
                    textToTranslate, finalResult, metadata);

            result.put("translatedText", finalResult);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("error", "Server error during translation.");
        }

        return result;
    }

    private String translateChunk(String textChunk, String targetLang) throws Exception {
        String encodedText = URLEncoder.encode(textChunk, StandardCharsets.UTF_8.toString());
        String langPair = URLEncoder.encode("autodetect|" + targetLang, StandardCharsets.UTF_8.toString());

        String apiUrl = "https://api.mymemory.translated.net/get?q=" + encodedText + "&langpair=" + langPair;

        URL url = URI.create(apiUrl).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");

        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder apiResponse = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                apiResponse.append(line);
            }
            reader.close();
            return extractTranslatedText(apiResponse.toString());
        }
        return textChunk;
    }

    private List<String> splitTextIntoChunks(String text, int maxSize) {
        List<String> chunks = new ArrayList<>();
        int length = text.length();
        int start = 0;

        while (start < length) {
            if (length - start <= maxSize) {
                chunks.add(text.substring(start));
                break;
            }

            int end = start + maxSize;
            int breakPoint = -1;
            for (int i = end; i > start + (maxSize / 2); i--) {
                char c = text.charAt(i);
                if (c == '.' || c == '?' || c == '!' || c == '\n') {
                    breakPoint = i + 1;
                    break;
                }
            }

            if (breakPoint == -1) {
                for (int i = end; i > start + (maxSize / 2); i--) {
                    if (Character.isWhitespace(text.charAt(i))) {
                        breakPoint = i + 1;
                        break;
                    }
                }
            }

            if (breakPoint == -1) breakPoint = end;

            chunks.add(text.substring(start, breakPoint));
            start = breakPoint;
        }

        return chunks;
    }

    private String extractTranslatedText(String json) {
        String key = "\"translatedText\":\"";
        int startIndex = json.indexOf(key);
        if (startIndex == -1) return "";
        startIndex += key.length();
        int endIndex = json.indexOf("\"", startIndex);
        if (endIndex == -1) return "";
        return decodeUnicode(json.substring(startIndex, endIndex));
    }

    private String decodeUnicode(String input) {
        StringBuilder builder = new StringBuilder();
        int i = 0;
        while (i < input.length()) {
            char ch = input.charAt(i);
            if (ch == '\\' && i + 5 < input.length() && input.charAt(i + 1) == 'u') {
                try {
                    int codePoint = Integer.parseInt(input.substring(i + 2, i + 6), 16);
                    builder.append((char) codePoint);
                    i += 6;
                    continue;
                } catch (NumberFormatException e) {}
            }
            builder.append(ch);
            i++;
        }
        return builder.toString();
    }

    private String escapeJson(String text) {
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
