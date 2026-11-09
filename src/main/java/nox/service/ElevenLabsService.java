package nox.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ElevenLabsService {

    private static final String STT_URL = "https://api.elevenlabs.io/v1/speech-to-text";

    public static String transcribeAudioBytes(byte[] audioBytes, String fileName, String apiKey)
            throws IOException, InterruptedException {
        String boundary = "----ServletBoundary" + UUID.randomUUID().toString();
        byte[] multipartData = buildMultipartBody(audioBytes, fileName, boundary);

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(STT_URL))
                .header("xi-api-key", apiKey)
                .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                .POST(HttpRequest.BodyPublishers.ofByteArray(multipartData))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            String responseBody = response.body();
            // Extract the "text" field from JSON using Regex (No Jackson JARs needed!)
            Matcher matcher = Pattern.compile("\"text\"\\s*:\\s*\"(.*?)\"").matcher(responseBody);
            if (matcher.find()) {
                // Unescape JSON special characters
                return matcher.group(1).replace("\\\"", "\"").replace("\\n", "\n");
            }
            return responseBody;
        } else {
            throw new IOException("ElevenLabs returned status " + response.statusCode());
        }
    }

    private static byte[] buildMultipartBody(byte[] fileBytes, String fileName, String boundary) {
        StringBuilder mimeHeader = new StringBuilder();
        
        // 1. Model ID field
        mimeHeader.append("--").append(boundary).append("\r\n");
        mimeHeader.append("Content-Disposition: form-data; name=\"model_id\"\r\n\r\n");
        mimeHeader.append("scribe_v2\r\n");

        // 2. File field
        mimeHeader.append("--").append(boundary).append("\r\n");
        mimeHeader.append("Content-Disposition: form-data; name=\"file\"; filename=\"")
                  .append(fileName != null && !fileName.isEmpty() ? fileName : "audio.mp3")
                  .append("\"\r\n");
        mimeHeader.append("Content-Type: audio/mpeg\r\n\r\n");

        byte[] headerBytes = mimeHeader.toString().getBytes(StandardCharsets.UTF_8);
        byte[] footerBytes = ("\r\n--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8);

        byte[] bodyBytes = new byte[headerBytes.length + fileBytes.length + footerBytes.length];
        System.arraycopy(headerBytes, 0, bodyBytes, 0, headerBytes.length);
        System.arraycopy(fileBytes, 0, bodyBytes, headerBytes.length, fileBytes.length);
        System.arraycopy(footerBytes, 0, bodyBytes, headerBytes.length + fileBytes.length, footerBytes.length);

        return bodyBytes;
    }
}
