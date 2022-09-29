CREATE TABLE users
(
    id       SERIAL PRIMARY KEY,
    username VARCHAR NOT NULL UNIQUE,
    password VARCHAR NOT NULL
);

INSERT INTO users(id, username, password)
VALUES (0, 'test', '$2b$12$PVhM2DgrT9aH19ozic8v9u06tzb.Q2c9IE/qrJ4QvfyPdMlY3X9hS');
