DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS work_motivation_category CASCADE;
DROP TABLE IF EXISTS work_motivation_question CASCADE;
DROP TABLE IF EXISTS result_header CASCADE;
DROP TABLE IF EXISTS work_motivation_result CASCADE;
DROP TABLE IF EXISTS language CASCADE;
DROP TABLE IF EXISTS english_language_difficulty CASCADE;
DROP TABLE IF EXISTS english_language_text CASCADE;
DROP TABLE IF EXISTS english_language_question CASCADE;
DROP TABLE IF EXISTS english_language_option CASCADE;
DROP TABLE IF EXISTS english_language_essay_topic CASCADE;
DROP TABLE IF EXISTS english_language_result_essay CASCADE;
DROP TABLE IF EXISTS english_language_result CASCADE;
DROP TABLE IF EXISTS social_situation_type CASCADE;
DROP TABLE IF EXISTS social_situation_media CASCADE;
DROP TABLE IF EXISTS social_situation_question CASCADE;
DROP TABLE IF EXISTS social_situation_result CASCADE;

CREATE TABLE language
(
    hu VARCHAR PRIMARY KEY,
    gb VARCHAR
);

CREATE TABLE users
(
    id         SERIAL PRIMARY KEY,
    username   VARCHAR(25) UNIQUE NOT NULL,
    password   VARCHAR            NOT NULL,
    email      VARCHAR            NOT NULL UNIQUE,
    first_name VARCHAR            NOT NULL,
    last_name  VARCHAR            NOT NULL,
    birthday   DATE               NOT NULL,
    is_admin   BOOLEAN            NOT NULL DEFAULT FALSE,
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
    id      SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    date    DATE    NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE work_motivation_result
(
    id               SERIAL PRIMARY KEY,
    question_id      INTEGER NOT NULL,
    result_header_id INTEGER NOT NULL,
    score            INTEGER NOT NULL,
    FOREIGN KEY (question_id) REFERENCES work_motivation_question (id),
    FOREIGN KEY (result_header_id) REFERENCES result_header (id) ON DELETE CASCADE
);

CREATE TABLE english_language_difficulty
(
    id    SERIAL PRIMARY KEY,
    title VARCHAR NOT NULL
);

CREATE TABLE english_language_text
(
    id            SERIAL PRIMARY KEY,
    text          VARCHAR NOT NULL,
    difficulty_id INTEGER NOT NULL,
    FOREIGN KEY (difficulty_id) REFERENCES english_language_difficulty (id) ON DELETE CASCADE
);

CREATE TABLE english_language_question
(
    id       SERIAL PRIMARY KEY,
    text_id  INTEGER NOT NULL,
    question VARCHAR NOT NULL,
    FOREIGN KEY (text_id) REFERENCES english_language_text (id) ON DELETE CASCADE,
    CHECK ( question ILIKE '%.............%' )
);

CREATE TABLE english_language_option
(
    id          SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL,
    option      VARCHAR NOT NULL,
    correct     BOOLEAN NOT NULL,
    FOREIGN KEY (question_id) REFERENCES english_language_question (id) ON DELETE CASCADE
);

CREATE TABLE english_language_essay_topic
(
    id            SERIAL PRIMARY KEY,
    difficulty_id INTEGER NOT NULL,
    topic         VARCHAR NOT NULL,
    FOREIGN KEY (difficulty_id) REFERENCES english_language_difficulty (id) ON DELETE CASCADE
);

CREATE TABLE english_language_result_essay
(
    id               SERIAL PRIMARY KEY,
    topic_id         INTEGER NOT NULL,
    result_header_id INTEGER NOT NULL,
    essay            VARCHAR(2000),
    FOREIGN KEY (result_header_id) REFERENCES result_header (id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES english_language_essay_topic (id) ON DELETE CASCADE
);

CREATE TABLE english_language_result
(
    id        SERIAL PRIMARY KEY,
    option_id INTEGER NOT NULL,
    result_id INTEGER NOT NULL,
    FOREIGN KEY (option_id) REFERENCES english_language_option (id),
    FOREIGN KEY (result_id) REFERENCES result_header (id) ON DELETE CASCADE
);

CREATE TABLE social_situation_type
(
    id   SERIAL PRIMARY KEY,
    type VARCHAR(10) NOT NULL
);

CREATE TABLE social_situation_media
(
    id      SERIAL PRIMARY KEY,
    url     VARCHAR(50) NOT NULL,
    type_id INTEGER     NOT NULL,
    FOREIGN KEY (type_id) REFERENCES social_situation_type (id)
);

CREATE TABLE social_situation_question
(
    id       SERIAL PRIMARY KEY,
    question VARCHAR NOT NULL,
    media_id INTEGER NOT NULL,
    FOREIGN KEY (media_id) REFERENCES social_situation_media (id)
);

CREATE TABLE social_situation_result
(
    id          SERIAL PRIMARY KEY,
    answer      VARCHAR(2000) NOT NULL,
    question_id INTEGER       NOT NULL,
    user_id     INTEGER       NOT NULL,
    FOREIGN KEY (question_id) REFERENCES social_situation_question (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);



INSERT INTO language(hu, gb)
VALUES ('Főoldal', 'Home'),
       ('Kijelentkezés', 'Logout'),
       ('Bejelentkezés', 'Login'),
       ('Regisztráció', 'Register'),
       ('Tesztek', 'Tests'),
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
       ('Üdvözöllek a Salva Vita weboldalán!', E'Welcome on Salva Vita\'s website!'),
       ('Elérhető tesztek', 'Available tests'),
       ('Tovább az esszé íráshoz!', 'Onward to the essay writing!'),
       ('Teszt elküldése!', 'Send test!'),
       ('Biztos tovább szeretnél lépni?', 'Are you sure you want to continue?'),
       ('Probléme volt az adatok elküldésével, kérlek próbáld meg később!',
        'There was a problem sending your data, please try again later!'),
       ('Nincs jogosultságod ennek az oldalnak az eléréséhez!',
        E'You don\'t have a necessary permission to access this site!'),
        ('Tovább a', 'To the'),
        ('tesztre', 'test'),
        ('Munka motiváció','Work motivation'),
        ('Ennek a tesztnek a lényege, hogy felmérje a hozzáállásodat a munkához','The purpose of this test is to asses your work attitude'),
        ('Angol nyelv', 'English Language'),
        ('Alapfok','Elementary'),
        ('Ez a teszt felméri az alapfokú angol tudásod','This test assesses your skills in elementary english'),
        ('Középfok','Intermediate'),
        ('Ez a teszt felméri a középfokú angol tudásod','This test assesses your skills in intermediate english'),
        ('Felső középfok','Upper intermediate'),
        ('Ez a teszt felméri a felső középfokú angol tudásod','This test assesses your skills in upper intermediate english'),
        ('Szociális készségek','Social skills'),
        ('Teszt cím','Test name'),
        ('Teszt leírás','Test description'),
        ('Teszt kategória', 'Test category'),
        ('Munka-motivációs kérdőiv','Work motivation survey'),
        ('Tovább a teszthez','To the test'),
        ('Teszt eredmények PDF', 'Test results PDF');


INSERT INTO users(username, password, email, first_name, last_name, birthday, is_admin)
VALUES ('admin', '$2b$12$PVhM2DgrT9aH19ozic8v9u06tzb.Q2c9IE/qrJ4QvfyPdMlY3X9hS', 'admin@admin.hu', 'Pista', 'Kiss',
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

INSERT INTO english_language_difficulty(title)
VALUES ('Elementary'),
       ('Intermediate'),
       ('Upper-intermediate');

INSERT INTO english_language_text(text, difficulty_id)
VALUES ( 'To: DomParsons@nitromail.com

From: JamesFSharp@bmail.net

Subject: Hi

Hi Dom,

How are you? I’m fine. I’m at home, of course, because of lockdown. I started my engineering course at Manchester University last year, but I’m not there now. I went to Manchester in October and I stayed in the student accommodation. We had lectures in the lecture rooms for three weeks, but after that, we had to stay in our accommodation because of Covid-19. I studied by computer. I wanted to go out to bars and join a basketball team, but I couldn’t. Luckily, there were some cool students in my accommodation. I made some good friends and we had cool parties.

But now I’m at home. I’m still studying by computer. I have four hours of lectures every day and then I work on projects. Actually, it’s quite good. We can do a lot of things by computer. I use different software programmes, read articles, and have discussions with the other students. I enjoy those discussions because I’m alone most of the time. Dad and mum are both at work all day. I can’t leave my town or visit friends, so I work! I work much harder than I did at school!

I miss playing basketball, but I’m keeping active. I go jogging once a day. But I’m watching a lot of videos too.

I’m not going to Manchester before Easter, but I hope to go there after Easter. In the Easter Holidays, I’m going to work on a friend’s farm in Wales. I don’t know anything about farming, but it will be great to be somewhere different!

Hope you are well,

from James.'
, 1),
       ( 'If you love chocolate, maybe you have eaten a bar of Cadbury’s Bournville chocolate. But Bournville isn’t just the name of an English chocolate bar. It’s the name of a village which was built especially for workers at the Cadbury’s chocolate factory.
George and Richard Cadbury took over the cocoa and chocolate business from their father in 1861. A few years later, they decided to move the factory out of the centre of Birmingham, a city in the middle of England, to a new location where they could expand. They chose an area close to the railways and canals so that they could receive milk deliveries easily and send the finished products to stores across the country.

Here, the air was much cleaner than in the city centre, and the Cadbury brothers thought it would be a much healthier place for their employees to work. They named the site Bournville after a local river called ‘The Bourn’. ‘Ville’, the French word for town, was used because at the time, people thought French chocolate was the highest quality. The new factory opened in 1879. Close to it, they built a village where the factory workers could live. By 1900, there were 313 houses on the site, and many more were built later.

The Cadbury family were religious and believed that it was right to help other people. They thought their workers deserved to live and work in good conditions. In the factory, workers were given a fair wage, a pension and access to medical treatment. The village was also designed to provide the best possible conditions for workers too. The houses, although traditional in style, had modern interiors, indoor bathrooms and large gardens. The village provided everything that workers needed including a shop, a school and a community centre where evening classes were held to train young members of the workforce.

Since the Cadbury family believed that their workers and their families should be fit and healthy, they added a park with hockey and football pitches, a running track, bowling green, fishing lake, and an outdoor swimming pool. A large clubhouse was built in the park so that players could change their clothes and relax after a game. Dances and dinners were also held here for the factory workers, who were never charged to use any of the sports facilities. However, because the Cadbury’s believed that alcohol was bad for health and society, no pubs were ever built in Bourneville!

The Cadbury brothers were among the first business owners to ensure that their workers had good standards of living. Soon, other British factory owners were copying their ideas by providing homes and communities for their workers designed with convenience and health in mind. Today, over 25,000 people live in Bournville village. There are several facilities there to help people with special needs, such as care homes for the elderly, a hostel for people with learning difficulties and affordable homes for first-time homeowners and single people. Over a hundred years since the first house in Bournville Village was built, the aims of its founders are still carried out.'
, 2),
       ( 'Lorem ipsum dolor sit amet consectetur adipiscing elit tristique lectus curae, non facilisi dictumst mollis pharetra nec cum sociis. Parturient imperdiet turpis eu fames bibendum class porta euismod, ipsum tempor velit platea nascetur a fermentum litora dolor, pulvinar vel adipiscing porttitor vulputate interdum enim. Augue semper massa mollis imperdiet suscipit tortor orci ornare risus neque potenti, congue leo nisl consectetur penatibus feugiat fames ullamcorper curabitur a justo, magnis vulputate vestibulum mus dictumst ultrices tristique eu torquent elementum. Eget tristique sapien felis leo elit litora habitasse elementum congue vitae, mattis venenatis diam orci nec urna nisi netus ligula magna, convallis fusce dictum metus ullamcorper quisque arcu torquent mauris. Mollis sollicitudin nam augue sociis fringilla curae nibh faucibus, nullam fusce ullamcorper lorem curabitur aliquet a litora penatibus, cum sem velit hendrerit nostra egestas integer. Class leo lobortis cursus dui donec ultrices condimentum cum non, dictumst est pulvinar malesuada magnis mi ridiculus suspendisse aenean parturient, vestibulum venenatis ut nisi dolor nascetur ornare curabitur.

Magnis parturient nostra ligula eu cras ullamcorper, in ultricies a cum et curae, risus ut etiam dictumst magna. Etiam cum donec congue metus aliquam dictum, amet neque ligula consequat ornare, fermentum vulputate maecenas placerat ultricies. Cursus senectus dolor leo nullam potenti magna, ad himenaeos phasellus maecenas mus a ut, fermentum sagittis risus litora accumsan. Urna phasellus ridiculus conubia eleifend felis bibendum dui a aliquam, massa scelerisque diam posuere molestie aenean vel leo habitasse, nam sociis ultrices turpis torquent himenaeos quam senectus. Nec consectetur vehicula netus praesent ad sociosqu fames ante lorem tempus mi, posuere dictumst habitant ultrices quisque suscipit morbi ornare scelerisque. Lacinia faucibus fringilla eleifend magnis dui ultricies phasellus viverra, justo porta in commodo lobortis rhoncus vel tortor, ante senectus orci ipsum fusce natoque purus. Hac metus primis leo litora consequat rhoncus placerat purus consectetur, mattis quisque cursus adipiscing proin dui porttitor natoque, facilisi justo nullam elementum urna vel lacinia dis. Lorem adipiscing conubia porttitor pellentesque donec bibendum nibh cubilia torquent, venenatis lacus suscipit egestas lacinia potenti nunc tellus aliquam velit, litora quam pharetra sed ipsum facilisis cursus sociosqu.

Ante dignissim arcu suspendisse donec ultricies, elit accumsan himenaeos feugiat, vulputate neque orci venenatis. Pretium non tortor a mus magnis sociosqu dolor praesent dapibus ultricies augue vulputate, hendrerit integer lobortis penatibus curabitur primis ut class elit duis. Nisi erat hac sem nam curabitur faucibus rutrum diam, tempus odio vel posuere nisl etiam suscipit nullam, habitasse feugiat quam facilisi lectus est vulputate. Sapien congue turpis pulvinar non facilisi consectetur aliquam, eget lobortis vitae fusce potenti dui feugiat purus, orci ante tempus fermentum dapibus massa. Vehicula imperdiet porttitor senectus magna consequat sem litora fusce ante placerat natoque tellus, est nunc conubia suspendisse tempor auctor netus velit a viverra enim varius nullam, nibh bibendum fermentum fames vitae proin inceptos tincidunt phasellus molestie lacinia. Mattis congue nisi suspendisse non ornare vulputate sociosqu penatibus, nullam dignissim pulvinar integer convallis justo risus, dolor feugiat sem ultrices netus platea aptent. Nunc proin torquent hendrerit donec ullamcorper sem senectus hac, lobortis facilisis tempus interdum amet suspendisse libero bibendum aenean, cras dolor nibh parturient elit scelerisque netus. Luctus nibh mattis himenaeos sociosqu ultricies at conubia habitasse lacus parturient libero senectus auctor rutrum placerat, dignissim molestie integer phasellus imperdiet rhoncus mi ultrices vestibulum viverra diam lobortis ad nam.

Aliquam luctus tempor mattis donec ultricies ad tortor tincidunt, interdum scelerisque nisl risus nam venenatis arcu phasellus ut, etiam lorem hendrerit eu eget praesent proin. Commodo leo dictumst mauris quam cum erat torquent, potenti viverra sodales convallis tristique ut urna vitae, parturient porttitor blandit habitant nec sem. Tellus aliquam tristique sed vitae cum facilisis in, etiam gravida senectus dis urna primis ante inceptos, vestibulum auctor litora pharetra semper molestie. Fringilla enim nisi torquent turpis sed cursus adipiscing vel primis, aliquet urna elit porta magna feugiat egestas in ac, accumsan sit maecenas varius odio eleifend pulvinar mauris. Vehicula ultrices malesuada venenatis potenti porta quam ipsum suscipit nascetur consectetur, lacus facilisi donec lobortis semper taciti duis imperdiet nec, egestas est dui metus mauris vulputate cras integer orci. Dictumst metus nibh a egestas primis magna leo, tellus mi facilisis cubilia aliquet suscipit malesuada, massa at accumsan ultricies maecenas potenti.'
, 3);

-- The question must contain this: ............. / exactly 13 dots
-- .............
INSERT INTO english_language_question(text_id, question)
VALUES (1, 'James studies ............. at university.'),
       (1, 'James went to lectures in the lecture rooms at Manchester university for ............. weeks.'),
       (1, 'While in lockdown in Manchester, James and his friends ............. .............'),
       (1, 'James wanted to play ............. at university.'),
       (1, 'James watches ............. on his computer for four hours each day.'),
       (1, 'After listening to lectures, James works on .............'),
       (1, 'He likes having ............. with other students these days.'),
       (1, 'James goes ............. every day.'),
       (1, 'He hopes to return to Manchester ............. Easter.'),
       (1, 'At Easter, James is going to work at a .............'),
       (2, 'Bournville is .............'),
       (2, 'The new site for the chocolate factory was chosen because .............'),
       (2, 'Bournville takes its name from .............'),
       (2, 'The original houses in Bournville were .............'),
       (2, 'Workers at the Cadbury received .............'),
       (2, 'The extract shows that the Cadbury family were .............'),
       (2, '............. can live in special homes in Bournville.'),
       (2, 'The Cadbury family added a park for the workers, which had .............'),
       (2, 'In the Cadbury’s opinion alcohol was .............'),
       (2, 'The workers could have dinner in the .............'),
       (3, 'Question 1.............'),
       (3, 'Question 2.............'),
       (3, 'Question 3.............'),
       (3, 'Question 4.............'),
       (3, 'Question 5.............'),
       (3, 'Question 6.............'),
       (3, 'Question 7.............'),
       (3, 'Question 8.............'),
       (3, 'Question 9.............'),
       (3, 'Question 10.............');

INSERT INTO english_language_option(question_id, option, correct)
VALUES (1, 'marketing', FALSE), -- James studies ............. at university.
       (1, 'IT', FALSE),
       (1, 'engineering', TRUE),
       (1, 'agriculture', FALSE),
       (1, 'architecture', FALSE),
       (2, '1', FALSE),     -- -- James went to lectures in the lecture rooms at Manchester university for ............. weeks.
       (2, '2', FALSE),
       (2, '3', TRUE),
       (2, '4', FALSE),
       (2, '5', FALSE),
       (3, 'wrote mails', FALSE),   -- While in lockdown in Manchester, James and his friends ............. .............
       (3, 'studied hard', FALSE),
       (3, 'had parties', TRUE),
       (3, 'played basketball', FALSE),
       (3, 'did nothing', FALSE),
       (4, 'softball', FALSE),  -- James wanted to play ............. at university.
       (4, 'football', FALSE),
       (4, 'basketball', TRUE),
       (4, 'volleyball', FALSE),
       (4, 'handball', FALSE),
       (5, 'TV series', FALSE), -- James watches ............. on his computer for four hours each day.
       (5, 'movies', FALSE),
       (5, 'lectures', TRUE),
       (5, 'project videos', FALSE),
       (5, 'funny images', FALSE),
       (6, 'his body', FALSE),  -- After listening to lectures, James works on .............
       (6, 'the garden', FALSE),
       (6, 'projects', TRUE),
       (6, 'homework', FALSE),
       (6, 'articles', FALSE),
       (7, 'basketball matches', FALSE),    -- He likes having ............. with other students these days.
       (7, 'meals', FALSE),
       (7, 'discussions', TRUE),
       (7, 'joint joggings', FALSE),
       (7, 'meetings', FALSE),
       (8, 'to the church', FALSE), -- James goes ............. every day.
       (8, 'playing basketball', FALSE),
       (8, 'jogging', TRUE),
       (8, 'shopping', FALSE),
       (8, 'to the toilet', FALSE),
       (9, 'before', FALSE),    -- He hopes to return to Manchester ............. Easter.
       (9, 'at', FALSE),
       (9, 'after', TRUE),
       (9, 'next year before', FALSE),
       (9, 'next year after', FALSE),
       (10, 'post office', FALSE),  -- At Easter, James is going to work at a .............
       (10, 'construction', FALSE),
       (10, 'farm', TRUE),
       (10, 'cinema', FALSE),
       (10, 'shopping center', FALSE),
       (11, 'a chocolate factory', FALSE),  -- Bournville is .............
       (11, 'a river', FALSE),
       (11, 'a village', TRUE),
       (11, 'the founder of a chocolate factory', FALSE),
       (11, 'a chocolate bunny', FALSE),
       (12, 'it was close to farms which provided milk', FALSE),    -- The new site for the chocolate factory was chosen because .............
       (12, 'it was easy to build there', FALSE),
       (12, 'it was close to several transportation routes', TRUE),
       (12, 'a lot of people lived nearby.', FALSE),
       (12, 'it was in the centre of the city', FALSE),
       (13, 'a local town', FALSE), -- Bournville takes its name from .............
       (13, 'a French town', FALSE),
       (13, 'a local river and a French word', TRUE),
       (13, 'a kind of French chocolate', FALSE),
       (13, 'a local river', FALSE),
       (14, 'free for workers', FALSE), -- The original houses in Bournville were .............
       (14, 'large', FALSE),
       (14, 'traditional in appearance', TRUE),
       (14, 'built by the factory workers', FALSE),
       (14, 'had no garden', FALSE),
       (15, 'financial social support', FALSE), -- Workers at the Cadbury received .............
       (15, 'free health care', FALSE),
       (15, 'pensions', TRUE),
       (15, 'dancing lessons', FALSE),
       (15, 'free food and drink', FALSE),
       (16, 'sporty', FALSE), -- The extract shows that the Cadbury family were .............
       (16, 'careful', FALSE),
       (16, 'kind', TRUE),
       (16, 'mean', FALSE),
       (16, 'lazy', FALSE),
       (17, 'First-time buyers', FALSE), -- ............. can live in special homes in Bournville.
       (17, 'Single people', FALSE),
       (17, 'People with learning problems', TRUE),
       (17, 'Chocolate factory workers', FALSE),
       (17, 'Poor people', FALSE),
       (18, 'billiard tables', FALSE), -- The Cadbury family added a park for the workers, which had .............
       (18, 'a golf course', FALSE),
       (18, 'a fishing lake', TRUE),
       (18, 'a diving pool', FALSE),
       (18, 'several basketball courts', FALSE),
       (19, 'cheap', FALSE), -- In the Cadbury’s opinion alcohol was .............
       (19, 'hard to get', FALSE),
       (19, 'unhealthy', TRUE),
       (19, 'made by Satan', FALSE),
       (19, 'a luxury item', FALSE),
       (20, 'pub', FALSE), -- The workers could have dinner in the .............
       (20, 'factory', FALSE),
       (20, 'clubhouse', TRUE),
       (20, 'community centre', FALSE),
       (20, 'restaurant', FALSE),
       (21, 'Option 1', FALSE),
       (21, 'Option 2', FALSE),
       (21, 'Option 3', TRUE),
       (21, 'Option 4', FALSE),
       (21, 'Option 5', FALSE),
       (22, 'Option 1', FALSE),
       (22, 'Option 2', FALSE),
       (22, 'Option 3', TRUE),
       (22, 'Option 4', FALSE),
       (22, 'Option 5', FALSE),
       (23, 'Option 1', FALSE),
       (23, 'Option 2', FALSE),
       (23, 'Option 3', TRUE),
       (23, 'Option 4', FALSE),
       (23, 'Option 5', FALSE),
       (24, 'Option 1', FALSE),
       (24, 'Option 2', FALSE),
       (24, 'Option 3', TRUE),
       (24, 'Option 4', FALSE),
       (24, 'Option 5', FALSE),
       (25, 'Option 1', FALSE),
       (25, 'Option 2', FALSE),
       (25, 'Option 3', TRUE),
       (25, 'Option 4', FALSE),
       (25, 'Option 5', FALSE),
       (26, 'Option 1', FALSE),
       (26, 'Option 2', FALSE),
       (26, 'Option 3', TRUE),
       (26, 'Option 4', FALSE),
       (26, 'Option 5', FALSE),
       (27, 'Option 1', FALSE),
       (27, 'Option 2', FALSE),
       (27, 'Option 3', TRUE),
       (27, 'Option 4', FALSE),
       (27, 'Option 5', FALSE),
       (28, 'Option 1', FALSE),
       (28, 'Option 2', FALSE),
       (28, 'Option 3', TRUE),
       (28, 'Option 4', FALSE),
       (28, 'Option 5', FALSE),
       (29, 'Option 1', FALSE),
       (29, 'Option 2', FALSE),
       (29, 'Option 3', TRUE),
       (29, 'Option 4', FALSE),
       (29, 'Option 5', FALSE),
       (30, 'Option 1', FALSE),
       (30, 'Option 2', FALSE),
       (30, 'Option 3', TRUE),
       (30, 'Option 4', FALSE),
       (30, 'Option 5', FALSE);

INSERT INTO english_language_essay_topic(difficulty_id, topic)
VALUES (1, 'School students should be allowed to curate their high school curriculum.'),
       (2, 'The role of physical education in the school system.'),
       (3, 'Should the death sentence be implemented globally?');

INSERT INTO social_situation_type(type)
VALUES ('image'),
       ('video');

INSERT INTO social_situation_media(url, type_id)
VALUES ('https://www.youtube.com/watch?v=kMMH8rA1ggI', 2),
       ('https://www.youtube.com/watch?v=fNFzfwLM72c', 2),
       ('../static/img/img01.png', 1),
       ('../static/img/img02.png', 1);

INSERT INTO social_situation_question(question, media_id)
VALUES ('Why do they react the way they do?', 1),
       ('Have you ever found yourself or experienced a similar situation? Please tell me about it.', 1),
       ('What did you feel?', 1),
       ('What did you feel? How did you react?', 3);
