package nox.controller;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;
import nox.service.ActivityLogger;

@RestController
@RequestMapping("/api/summary")
public class SummaryController {

    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";

    private final HttpClient client = HttpClient.newHttpClient();

    @PostMapping
    public Map<String, Object> summarize(@RequestParam("text") String transcript,
                                         HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        if (transcript == null || transcript.trim().isEmpty()) {
            result.put("error", "Transcript text parameter is required.");
            return result;
        }

        String apiKey = System.getenv("GROQ_API_KEY");
        if (apiKey == null || apiKey.isBlank()) {
            result.put("error", "Groq is not configured on the server.");
            return result;
        }

        try {
            String systemPrompt = "You are an executive assistant. Detect the language of the provided transcript and generate a clear 2-3 sentence summary in that exact same language. Do NOT state what language the text is in, do NOT include any introductory or conversational remarks, and respond ONLY with the concise summary text.";

            String jsonBody = String.format(
                "{\"model\": \"openai/gpt-oss-120b\", \"messages\": [{\"role\": \"system\", \"content\": \"%s\"}, {\"role\": \"user\", \"content\": \"%s\"}]}",
                escapeJson(systemPrompt),
                escapeJson(transcript)
            );

            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(GROQ_URL))
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> apiResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            if (apiResponse.statusCode() == 200) {
                String summaryText = extractMessageContent(apiResponse.body());
                ActivityLogger.log(session, ActivityLogger.TYPE_SUMMARY, "Text Summary",
                        transcript.trim(), summaryText, "{}");
                result.put("summary", summaryText);
            } else {
                result.put("error", "Groq API returned status " + apiResponse.statusCode());
            }
        } catch (Exception e) {
            System.err.println("Groq request failed (" + e.getClass().getSimpleName() + ").");
            result.put("error", "Server error generating summary.");
        }

        return result;
    }

    private String extractMessageContent(String responseBody) {
        Pattern pattern = Pattern.compile("\"content\"\\s*:\\s*\"(.*?)\"(?=\\s*,\\s*\"|\\s*\\})", Pattern.DOTALL);
        Matcher matcher = pattern.matcher(responseBody);
        if (matcher.find()) {
            return matcher.group(1)
                    .replace("\\\"", "\"")
                    .replace("\\n", "\n")
                    .replace("\\\\", "\\");
        }
        return responseBody;
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
