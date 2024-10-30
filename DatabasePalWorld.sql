-- Create a database for Pal World Tracker
DROP DATABASE IF EXISTS pal_world_tracker;
CREATE DATABASE pal_world_tracker;
USE pal_world_tracker;

-- 1. Users Table: Stores player/user information
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Pals Table: Stores all available Pals in the game
CREATE TABLE pals (
    pal_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    element VARCHAR(50) NOT NULL,
    max_level INT NOT NULL,
    is_legendary BOOLEAN DEFAULT FALSE
);

-- 3. Skills Table: Stores all skills available to Pals
CREATE TABLE skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

-- 4. Pal Skills Relations: Many-to-Many relationship between Pals and Skills
CREATE TABLE pal_skills (
    pal_id INT,
    skill_id INT,
    PRIMARY KEY (pal_id, skill_id),
    FOREIGN KEY (pal_id) REFERENCES pals(pal_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);

-- 5. Breeding Table: Tracks which two Pals can breed to produce an offspring
CREATE TABLE breeding (
    breeding_id INT AUTO_INCREMENT PRIMARY KEY,
    parent_1_id INT,
    parent_2_id INT,
    offspring_id INT,
    FOREIGN KEY (parent_1_id) REFERENCES pals(pal_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_2_id) REFERENCES pals(pal_id) ON DELETE CASCADE,
    FOREIGN KEY (offspring_id) REFERENCES pals(pal_id) ON DELETE CASCADE
);

-- 6. User Collections: Tracks what Pals a user owns
CREATE TABLE user_collections (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    pal_id INT,
    current_level INT,
    date_acquired DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pal_id) REFERENCES pals(pal_id) ON DELETE CASCADE
);

-- Optional Indexes for Performance
CREATE INDEX idx_user_id ON user_collections(user_id);
CREATE INDEX idx_pal_id ON user_collections(pal_id);

-- Insert Sample Data: Users
INSERT INTO users (username, email, password_hash) 
VALUES ('Jessica', 'jessica@example.com', 'hashedpassword123'),
       ('Paul', 'paul@example.com', 'hashedpassword456');

-- Insert Sample Data: Pals
INSERT INTO pals (name, element, max_level, is_legendary) 
VALUES ('Lamball', 'Neutral', 50, FALSE),
       ('Cattiva', 'Neutral', 45, FALSE),
       ('Lifmunk', 'Grass', 50, FALSE),
       ('Foxparks', 'Fire', 55, FALSE),
       ('Aquakin', 'Water', 60, FALSE),
       ('Sparkit', 'Electric', 50, FALSE),
       ('Vanwyrm', 'Fire/Dark', 70, TRUE);

-- Insert Sample Data: Skills
INSERT INTO skills (skill_name, description) 
VALUES ('Adaptability', 'Increases effectiveness when in unfamiliar situations'),
       ('Quick Feet', 'Increases speed when affected by a status condition'),
       ('Blaze', 'Boosts fire moves in a pinch'),
       ('Overgrow', 'Boosts grass moves in a pinch'),
       ('Static', 'May cause paralysis on contact'),
       ('Aqua Jet', 'Priority water attack');

-- Insert Sample Data: Pal Skills Relations
INSERT INTO pal_skills (pal_id, skill_id) 
VALUES (1, 1), (1, 2),  -- Lamball's skills
       (2, 1), (2, 3),  -- Cattiva's skills
       (3, 4),          -- Lifmunk's skill
       (5, 6);           -- Aquakin's skill

-- Insert Sample Data: Breeding Relations
INSERT INTO breeding (parent_1_id, parent_2_id, offspring_id)
VALUES (1, 2, 3);  -- Lamball + Cattiva = Lifmunk

-- Insert Sample Data: User Collections (What Pals a User Owns)
INSERT INTO user_collections (user_id, pal_id, current_level, date_acquired)
VALUES (1, 1, 10, '2024-01-15'), -- Jessica owns Lamball
       (1, 2, 20, '2024-02-01'), -- Jessica owns Cattiva
       (2, 4, 30, '2024-03-10'), -- Paul owns Foxparks
       (2, 5, 40, '2024-04-15'); -- Paul owns Aquakin

-- Example Queries

-- 1. Retrieve all Pals owned by a user (Jessica)
SELECT u.username, p.name AS pal_name, p.element, uc.current_level, uc.date_acquired
FROM user_collections uc
JOIN users u ON uc.user_id = u.user_id
JOIN pals p ON uc.pal_id = p.pal_id
WHERE u.username = 'Jessica';

-- 2. List all skills for a specific Pal (Lifmunk)
SELECT p.name AS pal_name, s.skill_name, s.description
FROM pal_skills ps
JOIN pals p ON ps.pal_id = p.pal_id
JOIN skills s ON ps.skill_id = s.skill_id
WHERE p.name = 'Lifmunk';

-- 3. Retrieve breeding pairs and their offspring
SELECT p1.name AS parent_1, p2.name AS parent_2, po.name AS offspring
FROM breeding b
JOIN pals p1 ON b.parent_1_id = p1.pal_id
JOIN pals p2 ON b.parent_2_id = p2.pal_id
JOIN pals po ON b.offspring_id = po.pal_id;

-- 4. Retrieve all legendary Pals owned by users
SELECT u.username, p.name AS pal_name, p.element, p.max_level
FROM user_collections uc
JOIN users u ON uc.user_id = u.user_id
JOIN pals p ON uc.pal_id = p.pal_id
WHERE p.is_legendary = TRUE;
