package nox.controller;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import nox.service.ActivityLogger;
import nox.service.ElevenLabsService;

@RestController
@RequestMapping("/api/transcribe")
public class TranscribeController {

    @PostMapping
    public Map<String, Object> transcribe(@RequestParam("audio") MultipartFile audioFile,
                                          HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        try {
            if (audioFile == null || audioFile.isEmpty()) {
                result.put("error", "No audio file received.");
                return result;
            }

            String apiKey = System.getenv("ELEVENLABS_API_KEY");
            if (apiKey == null || apiKey.isBlank()) {
                result.put("error", "ElevenLabs is not configured on the server.");
                return result;
            }

            byte[] audioBytes = audioFile.getBytes();
            String fileName = audioFile.getOriginalFilename();

            String transcriptText = ElevenLabsService.transcribeAudioBytes(audioBytes, fileName, apiKey);

            String metadata = "{\"fileName\": \"" + escapeJson(fileName) + "\", \"fileSizeKB\": " + (audioFile.getSize() / 1024) + "}";
            ActivityLogger.log(session, ActivityLogger.TYPE_TRANSCRIBE, fileName,
                    transcriptText, transcriptText, metadata);

            result.put("text", transcriptText);
        } catch (Exception e) {
            System.err.println("Transcription failed (" + e.getClass().getSimpleName() + ").");
            result.put("error", "Server error transcribing audio.");
        }

        return result;
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}
