package nox.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class HistoryItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String featureType;
    private String title;
    private String inputText;
    private String outputText;
    private String metadata;
    private Timestamp createdAt;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFeatureType() { return featureType; }
    public void setFeatureType(String featureType) { this.featureType = featureType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getInputText() { return inputText; }
    public void setInputText(String inputText) { this.inputText = inputText; }

    public String getOutputText() { return outputText; }
    public void setOutputText(String outputText) { this.outputText = outputText; }

    public String getMetadata() { return metadata; }
    public void setMetadata(String metadata) { this.metadata = metadata; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
