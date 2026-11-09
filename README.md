# NOX · Vox & Note

NOX is a web app for turning lectures, meetings, and voice notes into transcripts. You can ask questions about a transcript, summarize or translate it, and extract action items for a to-do list.

## Why use NOX?

One recording can serve several purposes. After a meeting, you can extract action items and check what was said about a deadline. After a lecture, you can make a short recap, look up details in the transcript, or listen to a section again as synthesized speech. Keeping these tools in one workspace reduces the need to copy notes between apps. Signed-in users can revisit saved results in their activity history.

## Features

| Feature | What you can do |
| --- | --- |
| Speech to text | Record in the browser or upload an audio file and transcribe it with ElevenLabs. |
| Summaries and text polishing | Condense a transcript into a short recap or clean it up into readable notes. |
| Transcript Q&A | Ask questions using the transcript as context. |
| Task extraction | Turn notes or transcripts into a to-do list and save reminders with due dates. |
| Translation | Translate text between English and Burmese using MyMemory. |
| Text to speech | Listen to written text or download the generated audio. |
| Activity history | Revisit and manage results from previous sessions. |

## Run locally

NOX uses **Java 21**, **Spring Boot**, **JSP**, **Maven**, and **MySQL**. The AI features use Groq and ElevenLabs. Audio and text are sent to the relevant external service when you use those features.

### 1. Set up MySQL

The default database is `notesassistant` on `localhost:3306`. For a fresh local database, run the following in MySQL Workbench using an account that can create the database and table.

```sql
CREATE DATABASE IF NOT EXISTS notesassistant CHARACTER SET utf8mb4;
USE notesassistant;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);
```

NOX creates its activity history table as needed. The [reminder defaults script](user_settings.sql) contains the `user_settings` table definition. Reminder storage also expects a `reminders` table and uses `todo_list` when linking a reminder to a task. This repository does not include the schema for those two tables.

### 2. Configure the server environment

Set these variables in the PowerShell session, IDE launch configuration, or Tomcat service that starts NOX. Keep real credentials out of committed files.

| Variable | Used for |
| --- | --- |
| `GROQ_API_KEY` | Text polishing, Q&A, summaries, and task extraction |
| `ELEVENLABS_API_KEY` | Audio transcription |
| `NOX_DB_USER` | MySQL username |
| `NOX_DB_PASSWORD` | MySQL password |
| `NOX_DB_URL` | Optional JDBC URL. Defaults to the local MySQL database `notesassistant` on port 3306. |

### 3. Start NOX

From the project directory, run:

```powershell
mvn spring-boot:run
```

Open [NOX on localhost](http://localhost:8080), register a local account, and try recording or uploading a short clip.
