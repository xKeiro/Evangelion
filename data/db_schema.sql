DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS work_motivation_category CASCADE;
DROP TABLE IF EXISTS work_motivation_question CASCADE;
DROP TABLE IF EXISTS result_header CASCADE;
DROP TABLE IF EXISTS work_motivation_result CASCADE;
DROP TABLE IF EXISTS language CASCADE;

CREATE TABLE language
(
    hu TEXT PRIMARY KEY,
    en TEXT
);

CREATE TABLE users
(
    username   VARCHAR(25) PRIMARY KEY,
    password   VARCHAR NOT NULL,
    email      VARCHAR NOT NULL UNIQUE,
    first_name VARCHAR NOT NULL,
    last_name  VARCHAR NOT NULL,
    birthday   DATE    NOT NULL,
    is_admin   BOOLEAN NOT NULL DEFAULT FALSE,
    CHECK (email ILIKE '%@%.%')
);

CREATE TABLE work_motivation_category
(
    id    SERIAL PRIMARY KEY,
    title VARCHAR NOT NULL
);

CREATE TABLE work_motivation_question
(
    id          SERIAL PRIMARY KEY,
    title       VARCHAR NOT NULL UNIQUE,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES work_motivation_category (id) ON DELETE CASCADE
);

CREATE TABLE result_header
(
    id       SERIAL PRIMARY KEY,
    username VARCHAR(25) NOT NULL,
    date     DATE        NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (username) REFERENCES users (username)
);

CREATE TABLE work_motivation_result
(
    id               SERIAL PRIMARY KEY,
    question_id      INTEGER NOT NULL,
    result_header_id INTEGER NOT NULL,
    score            INTEGER NOT NULL,
    FOREIGN KEY (question_id) REFERENCES work_motivation_question (id),
    FOREIGN KEY (result_header_id) REFERENCES result_header (id)
);

INSERT INTO language(hu, en)
VALUES ('Főoldal', 'Home'),
       ('Kijelentkezés', 'Logout'),
       ('Bejelentkezés', 'Login'),
       ('Regisztráció', 'Register'),
       ('Munka motiváció teszt', 'Work Motivation Test'),
       ('Bejelentkezve mint', 'Logged in as'),
       ('Felhasználónév', 'Username'),
       ('Jelszó', 'Password'),
       ('E-mail', 'E-mail'),
       ('Családnév', 'Last name'),
       ('Keresztnév', 'First name'),
       ('Születési idő', 'Birthday'),
       ('Elküldés', 'Submit'),
       ('A bejelentkezés sikertelen!', 'Login attempt failed!'),
       ('A felhasználónév foglalt!', 'Username taken!'),
       ('Kérlek válassz egy másikat!', 'Please choose a new one!'),
       ('Ellenőrizd a felhasználóneved és a jelszavad!', 'Check your username and password!'),
       ('Regisztráció szükséges ennek az oldalnak az eléréséhez!', 'Registration needed needed to access this site!'),
       ('Válaszok elküldése', 'Send answers'),
       ('A teszted eredménye elküldve!', 'The result of your test has been submitted!'),
       ('Kérlek válaszolj az összes kérdésre elküldés előtt!',
        'Please answer all questions before sending your answers!'),
       ('Üdvözöllek a Salva Vita weboldalán!', E'Welcome on Salva Vita\'s website!');


INSERT INTO users(username, password, email, first_name, last_name, birthday, is_admin)
VALUES ('admin', '$2b$12$PVhM2DgrT9aH19ozic8v9u06tzb.Q2c9IE/qrJ4QvfyPdMlY3X9hS', 'admin@admin', 'Pista', 'Kiss',
        '1990-01-01', TRUE), ---pw: asd
       ('test', '$2b$12$PVhM2DgrT9aH19ozic8v9u06tzb.Q2c9IE/qrJ4QvfyPdMlY3X9hS', 'test@test.hu', 'Pista', 'Kiss',
        '1990-01-01', FALSE); ---pw: asd


INSERT INTO work_motivation_category(title)
VALUES ('Szellemi ösztönzés'),
       ('Altruizmus'),
       ('Anyagiak'),
       ('Változatosság'),
       ('Függetlenség'),
       ('Presztízs'),
       ('Esztétikum'),
       ('Társas kapcsolatok'),
       ('Játékosság'),
       ('Önérvényesítés'),
       ('Hierarchia'),
       ('Humán értékek'),
       ('Munkateljesítmény'),
       ('Kreativitás'),
       ('Irányítás');

INSERT INTO work_motivation_question(title, category_id)
VALUES ('... szüntelenül új, megoldatlan problémákba ütközik.', 1),
       ('... másokon segíthet.', 2),
       ('... sok pénzt keres.', 3),
       ('... változatos munkát végezhet.', 4),
       ('... szabadon dönthet a saját területén.', 5),
       ('... tekintélyt szerezhet munkájával.', 6),
       ('... akár művész is lehet.', 7),
       ('... a többiek közé tartozik.', 8),
       ('... pillanatnyi kedve dönti el, hogy mit csináljon.', 9),
       ('... megvalósítja önmagát.', 10),
       ('... tisztelheti a főnökét.', 11),
       ('... tehet valamit a társadalmi igazságosságért.', 12),
       ('... nem beszélhet mellé, mert csak jó vagy rossz megoldások léteznek.', 13),
       ('... másokat irányíthat.', 15),
       ('... új elképzeléseket alakíthat ki.', 14),
       ('... valami újat alkothat.', 14),
       ('... objektíven lemérheti munkája eredményét.', 13),
       ('... vezetője mindig helyesen dönt.', 11),
       ('... olyat is csinálhat, ami más szemében fölöslegesnek tűnhet.', 9),
       ('... szebbé teheti a világot.', 7),
       ('... önálló döntéseket hozhat.', 5),
       ('... gondtalan életet biztosíthat.', 3),
       ('... új gondolatokkal találkozhat.', 1),
       ('... vezetői képességeire szüksége lehet.', 15),
       ('... sikerét vagy kudarcát csak a következő nemzedék döntheti el.', 12),
       ('... személyes életstílusa érvényesülhet.', 10),
       ('... munkatársai egyben barátai is.', 8),
       ('... biztos lehet afelől, hogy munkájáért a többiek megbecsülik.', 6),
       ('... nem kell minduntalan ugyanazt csinálnia.', 4),
       ('... jót tehet mások érdekében.', 2),
       ('... más emberek javát szolgálhatja.', 2),
       ('... sokféle dolgot csinálhat.', 4),
       ('... (ember)re mások felnéznek.', 6),
       ('... jól kijön munkatársaival.', 8),
       ('... olyan életet élhet, amit legjobban szeret.', 10),
       ('... (ember)nek konfliktusokat kell vállalnia.', 12),
       ('... mások munkáját is irányíthatja.', 15),
       ('... szellemileg izgalmas munkát végezhet.', 1),
       ('... magas nyugdíjra számíthat.', 3),
       ('... munkájába másnak nincs beleszólása.', 5),
       ('... szépet teremthet.', 7),
       ('... olykor játszhat is.', 9),
       ('... (ember)nek megértő vezetője van.', 11),
       ('... szüntelenül fejlesztheti, tökéletesítheti önmagát.', 13),
       ('... új ötleteire mindig szükség van.', 14);
