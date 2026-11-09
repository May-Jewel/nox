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
@RequestMapping("/api/text")
public class TextController {

    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";

    private final HttpClient client = HttpClient.newHttpClient();

    @PostMapping
    public Map<String, Object> processText(@RequestParam("action") String action,
                                           @RequestParam("transcript") String transcript,
                                           @RequestParam(value = "query", required = false) String userQuery,
                                           HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        if (transcript == null || transcript.trim().isEmpty()) {
            result.put("error", "Transcript parameter is required.");
            return result;
        }

        String prompt;
        String activityTitle;

        if ("polish".equalsIgnoreCase(action)) {
            prompt = "You are an expert editor. Clean up the following raw transcription text. " +
                     "Fix grammar errors, remove filler words (like 'um', 'uh'), format it with clear headings, " +
                     "bullet points, and bold text where appropriate. Keep the original language.\n\n" +
                     "Raw Transcription:\n" + transcript;
            activityTitle = "Text Polish";
        } else if ("chat".equalsIgnoreCase(action)) {
            if (userQuery == null || userQuery.trim().isEmpty()) {
                result.put("error", "Query parameter is required for chat action.");
                return result;
            }
            prompt = "You are a smart assistant chatting with a user about their recorded audio. " +
                     "Answer the user's question based ONLY on the provided transcription context below.\n\n" +
                     "Context (Audio Transcript):\n" + transcript + "\n\n" +
                     "User Question: " + userQuery;
            activityTitle = "Q&A Chat";
        } else {
            result.put("error", "Invalid action. Use 'polish' or 'chat'.");
            return result;
        }

        String apiKey = System.getenv("GROQ_API_KEY");
        if (apiKey == null || apiKey.isBlank()) {
            result.put("error", "Groq is not configured on the server.");
            return result;
        }

        try {
            String jsonBody = String.format(
                "{\"model\": \"openai/gpt-oss-120b\", \"messages\": [{\"role\": \"user\", \"content\": \"%s\"}]}",
                escapeJson(prompt)
            );

            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(GROQ_URL))
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> apiResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            if (apiResponse.statusCode() == 200) {
                String resultText = extractMessageContent(apiResponse.body());

                String metadata = "{\"action\": \"" + escapeJson(action) + "\""
                        + (userQuery != null && !userQuery.trim().isEmpty()
                            ? ", \"query\": \"" + escapeJson(userQuery.trim()) + "\"" : "")
                        + "}";
                ActivityLogger.log(session, ActivityLogger.TYPE_QNA, activityTitle,
                        transcript, resultText, metadata);

                result.put("result", resultText);
            } else {
                result.put("error", "Groq API returned status " + apiResponse.statusCode());
            }
        } catch (Exception e) {
            System.err.println("Groq request failed (" + e.getClass().getSimpleName() + ").");
            result.put("error", "Server error processing text.");
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
