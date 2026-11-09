package nox.controller;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
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
@RequestMapping("/api/todolist")
public class TodoController {

    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";

    private final HttpClient client = HttpClient.newHttpClient();

    @PostMapping
    public Map<String, Object> extractTasks(@RequestParam("text") String transcriptText,
                                            HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        if (transcriptText == null || transcriptText.trim().isEmpty()) {
            result.put("error", "No text provided.");
            return result;
        }

        String apiKey = System.getenv("GROQ_API_KEY");
        if (apiKey == null || apiKey.isBlank()) {
            result.put("error", "Groq is not configured on the server.");
            return result;
        }

        try {
            String systemPrompt = "You are an executive assistant. Detect the language of the provided text. Process the text and respond ONLY in a valid JSON object with one key: \"tasks\": An array of short, clear action items extracted from the text in that exact same language.";

            String jsonBody = String.format(
                "{\"model\": \"openai/gpt-oss-120b\", \"response_format\": {\"type\": \"json_object\"}, \"messages\": [{\"role\": \"system\", \"content\": \"%s\"}, {\"role\": \"user\", \"content\": \"%s\"}]}",
                escapeJson(systemPrompt),
                escapeJson(transcriptText)
            );

            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(GROQ_URL))
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> apiResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            if (apiResponse.statusCode() == 200) {
                String contentJson = extractMessageContent(apiResponse.body());
                String tasksArray = extractJsonArray(contentJson, "tasks");

                int taskCount = countJsonStrings(tasksArray);
                String metadata = "{\"taskCount\": " + taskCount + "}";
                ActivityLogger.log(session, ActivityLogger.TYPE_TODO, "Task Extraction",
                        transcriptText.trim(), tasksArray, metadata);

                @SuppressWarnings("unchecked")
                List<String> tasks = parseJsonArray(tasksArray);
                result.put("tasks", tasks);
            } else {
                result.put("error", "Groq API returned status " + apiResponse.statusCode());
            }
        } catch (Exception e) {
            System.err.println("Groq request failed (" + e.getClass().getSimpleName() + ").");
            result.put("error", "Server error extracting tasks.");
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

    private String extractJsonArray(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + key + "\"\\s*:\\s*(\\[.*?\\])", Pattern.DOTALL);
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return "[]";
    }

    private List<String> parseJsonArray(String jsonArray) {
        List<String> result = new ArrayList<>();
        if (jsonArray == null || jsonArray.isEmpty() || "[]".equals(jsonArray)) return result;
        Pattern pattern = Pattern.compile("\"((?:[^\"\\\\]|\\\\.)*)\"");
        Matcher matcher = pattern.matcher(jsonArray);
        while (matcher.find()) {
            String value = matcher.group(1)
                    .replace("\\\"", "\"")
                    .replace("\\n", "\n")
                    .replace("\\\\", "\\");
            result.add(value);
        }
        return result;
    }

    private int countJsonStrings(String jsonArray) {
        if (jsonArray == null || jsonArray.isEmpty()) return 0;
        int count = 0;
        Pattern pattern = Pattern.compile("\"((?:[^\"\\\\]|\\\\.)*)\"");
        Matcher matcher = pattern.matcher(jsonArray);
        while (matcher.find()) {
            count++;
        }
        return count;
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
