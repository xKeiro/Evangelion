DROP TABLE IF EXISTS users CASCADE;


CREATE TABLE users
(
    username VARCHAR(25) NOT NULL UNIQUE PRIMARY KEY,
    password VARCHAR NOT NULL
);

INSERT INTO users(username, password)
VALUES ('test', '$2b$12$PVhM2DgrT9aH19ozic8v9u06tzb.Q2c9IE/qrJ4QvfyPdMlY3X9hS'); ---pw: asd
