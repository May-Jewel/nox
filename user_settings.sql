-- ============================================================================
-- NOX – user_settings table (per-user reminder defaults)
-- Run this against the `notesassistant` database.
-- Safe to run multiple times (IF NOT EXISTS).
-- ============================================================================
USE notesassistant;

CREATE TABLE IF NOT EXISTS user_settings (
    user_id                 INT PRIMARY KEY,
    default_offset_type     VARCHAR(20) NOT NULL DEFAULT '1_DAY_BEFORE',
    default_offset_minutes  BIGINT DEFAULT NULL,
    default_deadline_minutes BIGINT NOT NULL DEFAULT 1440, -- 24 hours
    created_at              DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at              DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- If the table already exists but is missing the deadline column, add it:
ALTER TABLE user_settings
    ADD COLUMN IF NOT EXISTS default_deadline_minutes BIGINT NOT NULL DEFAULT 1440
    AFTER default_offset_minutes;
