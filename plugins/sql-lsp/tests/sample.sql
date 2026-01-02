-- Sample SQL file for LSP plugin validation
-- This file contains various SQL constructs to test:
-- - LSP operations (syntax highlighting, completion, validation)
-- - Hook validation (linting, formatting)

-- Table creation with various data types
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    age INTEGER CHECK (age >= 0),
    metadata JSONB
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    published_at TIMESTAMP,
    view_count INTEGER DEFAULT 0,
    tags TEXT[]
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    parent_comment_id INTEGER REFERENCES comments(id)
);

-- Indexes for performance
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_published_at ON posts(published_at DESC) WHERE published_at IS NOT NULL;
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_users_email ON users(email);

-- Basic SELECT queries
SELECT id, username, email
FROM users
WHERE is_active = TRUE
ORDER BY created_at DESC
LIMIT 10;

-- JOIN query
SELECT
    u.username,
    p.title,
    p.published_at,
    COUNT(c.id) AS comment_count
FROM users u
INNER JOIN posts p ON p.user_id = u.id
LEFT JOIN comments c ON c.post_id = p.id
WHERE p.published_at IS NOT NULL
GROUP BY u.username, p.title, p.published_at
HAVING COUNT(c.id) > 5
ORDER BY p.published_at DESC;

-- Subquery example
SELECT username, email
FROM users
WHERE id IN (
    SELECT DISTINCT user_id
    FROM posts
    WHERE published_at > NOW() - INTERVAL '30 days'
);

-- Common Table Expression (CTE)
WITH recent_posts AS (
    SELECT
        user_id,
        COUNT(*) AS post_count,
        MAX(published_at) AS last_post
    FROM posts
    WHERE published_at > NOW() - INTERVAL '7 days'
    GROUP BY user_id
)
SELECT
    u.username,
    u.email,
    rp.post_count,
    rp.last_post
FROM users u
INNER JOIN recent_posts rp ON rp.user_id = u.id
ORDER BY rp.post_count DESC;

-- Window function
SELECT
    username,
    created_at,
    ROW_NUMBER() OVER (ORDER BY created_at) AS user_number,
    COUNT(*) OVER () AS total_users
FROM users
ORDER BY created_at;

-- Aggregate functions
SELECT
    DATE_TRUNC('day', published_at) AS day,
    COUNT(*) AS posts_published,
    AVG(view_count) AS avg_views,
    MAX(view_count) AS max_views
FROM posts
WHERE published_at IS NOT NULL
GROUP BY DATE_TRUNC('day', published_at)
ORDER BY day DESC;

-- INSERT statements
INSERT INTO users (username, email, age)
VALUES
    ('alice', 'alice@example.com', 28),
    ('bob', 'bob@example.com', 32),
    ('charlie', 'charlie@example.com', 25);

-- UPDATE statement
UPDATE users
SET
    updated_at = NOW(),
    is_active = FALSE
WHERE last_login < NOW() - INTERVAL '1 year';

-- DELETE statement
DELETE FROM comments
WHERE created_at < NOW() - INTERVAL '2 years';

-- Transaction example
BEGIN;

INSERT INTO posts (user_id, title, content, published_at)
VALUES (1, 'New Post', 'Content here', NOW());

UPDATE users
SET updated_at = NOW()
WHERE id = 1;

COMMIT;

-- View creation
CREATE VIEW active_users_with_posts AS
SELECT
    u.id,
    u.username,
    u.email,
    COUNT(p.id) AS post_count
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
WHERE u.is_active = TRUE
GROUP BY u.id, u.username, u.email;

-- TODO: Add more complex queries for testing
-- FIXME: Optimize the JOIN query performance
-- NOTE: Consider adding indexes on frequently queried columns
