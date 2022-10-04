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
    email      VARCHAR UNIQUE     NOT NULL,
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
    title   VARCHAR NOT NULL,
    url     VARCHAR NOT NULL,
    type_id INTEGER NOT NULL,
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
    result_id   INTEGER       NOT NULL,
    FOREIGN KEY (question_id) REFERENCES social_situation_question (id),
    FOREIGN KEY (result_id) REFERENCES result_header (id)
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
       ('Üdvözöllek Salva Vitán', 'Welcome to Salva Vita'),
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
       ('Munka motiváció', 'Work motivation'),
       ('Ennek a tesztnek a lényege, hogy felmérje a hozzáállásodat a munkához',
        'The purpose of this test is to asses your work attitude'),
       ('Angol nyelv', 'English Language'),
       ('Alapfok', 'Elementary'),
       ('Ez a teszt felméri az alapfokú angol tudásod', 'This test assesses your skills in elementary english'),
       ('Középfok', 'Intermediate'),
       ('Ez a teszt felméri a középfokú angol tudásod', 'This test assesses your skills in intermediate english'),
       ('Felső középfok', 'Upper intermediate'),
       ('Ez a teszt felméri a felső középfokú angol tudásod',
        'This test assesses your skills in upper intermediate english'),
       ('Szociális készségek', 'Social skills'),
       ('Teszt cím', 'Test name'),
       ('Teszt leírás', 'Test description'),
       ('Teszt kategória', 'Test category'),
       ('Munka-motivációs kérdőiv', 'Work motivation survey'),
       ('Tovább a teszthez', 'To the test'),
       ('Teszt eredmények PDF', 'Test results PDF'),
       ('SOKSZÍNŰSÉG','DIVERSITY'),
       ('Meggyőződésünk, hogy a munkahelyek meg tudják változtatni a világot, ha elköteleződnek a sokszínűség mellett. Gondoljunk csak bele, hogy több mint 4,5 millió ember tölti élete egyharmadát a munkahelyén Magyarországon. Képzeljük el, mi történne, ha itt megtanulnánk együttműködni olyan emberekkel, akik különböznek tőlünk? Egészen biztos, hogy a munkán kívüli szavaink és tetteink is megváltoznának.','We believe that workplaces can change the world if they commit to diversity. Just think, more than 4.5 million people spend a third of their lives at work in Hungary. Imagine what would happen if we learned to work with people here who are different from us? Our words and actions outside work would certainly change.'),
       ('MEGTÉRÜLÉS','PAY-OFF'),
       ('Ma már szinte minden nagyvállalat tudja, hogy a sokszínűség jó dolog, fontos dolog, hogy az a helyes, ha erre odafigyelünk. De tapasztalataink szerint még nem minden vállalat tudja, hogy gazdaságilag is a sokszínűség a racionális döntés. Számos kutatás bizonyítja ugyanis, hogy a sokszínű cégek, a valóban befogadó cégek üzleti eredménye jelentős mértékben meghaladja a többi vállalatét.','Today, almost every large company knows that diversity is a good thing, that it is important to do the right thing by paying attention to it. But in our experience, not all companies know that diversity is the rational economic choice. In fact, there is a lot of research showing that diverse companies, truly inclusive companies, significantly outperform other companies.'),
       ('BEFOGADÁS','INCLUSION'),
       ('A sokszínűségi célkitűzés önmagában azonban nem elég. A befogadásról nem elég beszélni, nem elég számokat kitűzni, azt művelni kell, tenni kell érte. Ebben tud segíteni a cégeknek a Salva Vita Alapítvány tanácsadással, szolgáltatásokkal, tréningekkel, vállalati rendezvényekkel, munkaerő közvetítésével, kiadványokkal. Mi azért dolgozunk, közel 30 éve, hogy segítsük a cégeket egy befogadó munkakörnyezet kialakításában. Keress minket! Együtt. Működünk.','But the diversity objective alone is not enough. Inclusion is not enough to talk about, it is not enough to set numbers, it must be cultivated, it must be acted upon. This is where the Salva Vita Foundation can help companies through advice, services, training, company events, recruitment, publications. We have been working for nearly 30 years to help companies create an inclusive working environment. Contact us! Together. We work.'),
       ('MEGTARTÁS','LOYALTY'),
       ('A megváltozott munkaképességű munkatársak egy megbízható és lojális munkavállalói kört alkotnak, akik produktivitása – az általános vélekedésekkel ellentétben – az átlagostól nem tér el, és hozzáállásukat tekintve elkötelezettebbek, lojálisabbak a munkáltatójuk irányába.','Disabled workers are a reliable and loyal group of employees who, contrary to common perceptions, are productive, not different from the average, and have a more committed and loyal attitude towards their employer.');


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
       ( 'In 2017, archaeologists discovered the remains of a Bronze Age chief in Lechlade, a town in the west of England. The finding is historically interesting as the artefacts with which he was buried indicate that he was very important. Plus, the manner of his burial was significantly different from other burials at the time. Even more fascinating was the discovery of an older man’s remains close to the chief’s. Archaeologists are puzzling over what the relationship between the two men could be, and why they were treated so differently from the norm at the time.

Interestingly, the chief was buried with the heads and hooves of four cattle around 4,200 ago. Carbon dating has revealed that the remains, which were found in an area where a skate park is to be built, date back to the Bronze Age. Archaeologist Andy Hood, who helped to excavate the site, said that it was common for Bronze Age chiefs to be buried with the skull and hooves of a single cattle, but that until now none had been uncovered with multiple cattle remains in the UK. This fact seems to indicate that this chief was especially important. Hood and his colleagues consider it likely that the animals were killed as part of the burial ceremony. The loss of four of them would have been a considerable sacrifice.

Other artefacts found near the chief include a copper dagger, a stone wrist guard, a fire-making kit and some jewellery. These items were typically buried alongside members of the “Beaker culture”. These were people who arrived in Britain from mainland Europe in around 2400BC. They were given this name due to the tall pots which looked like beakers that were typical of this culture. Usually, prominent people from this culture were buried with such a pot, but this chief was not. Archaeologists wonder whether this meant that this chief was especially revered among the Beaker society and was not symbolised by the typical pot.

The chieftain was buried at the centre of a circular pit. At the time, soil would have been piled on top of it. Near the chief, within the circle, were the remains of the older man, who was about 50-60 years old when he died. Newspapers have suggested that the older man was a priest who was sacrificed to help the chief in the afterlife. However, archaeologists say there is no evidence to support this idea. Even so, the older man’s burial is strange, as he was buried in an unusual seated position, with his legs going downwards into the earth. Bronze Age people, including the chief, were almost always buried on their sides. The reason for this unique position, the status of the chief and the relationship between the two men, may remain a mystery forever.'
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
       (3, '............. was/were discovered in a park in Lechlade, UK.'),
       (3, '............. was/were buried with the heads and hooves of four cattle.'),
       (3, '............. believe that the cattle were sacrificed.'),
       (3, '............. was/were buried with a beaker.'),
       (3, '............. was/were not buried with a beaker.'),
       (3, '............. was/were buried in a circular pit.'),
       (3, '............. thought the old man was a religious figure.'),
       (3, '............. believe that the old man was sacrificed.'),
       (3, '............. was/were buried in a sitting position.'),
       (3, '............. was/were buried with a dagger in most cases.');

INSERT INTO english_language_option(question_id, option, correct)
VALUES (1, 'marketing', FALSE),                                -- James studies ............. at university.
       (1, 'IT', FALSE),
       (1, 'engineering', TRUE),
       (1, 'agriculture', FALSE),
       (1, 'architecture', FALSE),
       (2, '1',
        FALSE),                                                -- -- James went to lectures in the lecture rooms at Manchester university for ............. weeks.
       (2, '2', FALSE),
       (2, '3', TRUE),
       (2, '4', FALSE),
       (2, '5', FALSE),
       (3, 'wrote mails', FALSE),                              -- While in lockdown in Manchester, James and his friends ............. .............
       (3, 'studied hard', FALSE),
       (3, 'had parties', TRUE),
       (3, 'played basketball', FALSE),
       (3, 'did nothing', FALSE),
       (4, 'softball', FALSE),                                 -- James wanted to play ............. at university.
       (4, 'football', FALSE),
       (4, 'basketball', TRUE),
       (4, 'volleyball', FALSE),
       (4, 'handball', FALSE),
       (5, 'TV series', FALSE),                                -- James watches ............. on his computer for four hours each day.
       (5, 'movies', FALSE),
       (5, 'lectures', TRUE),
       (5, 'project videos', FALSE),
       (5, 'funny images', FALSE),
       (6, 'his body', FALSE),                                 -- After listening to lectures, James works on .............
       (6, 'the garden', FALSE),
       (6, 'projects', TRUE),
       (6, 'homework', FALSE),
       (6, 'articles', FALSE),
       (7, 'basketball matches', FALSE),                       -- He likes having ............. with other students these days.
       (7, 'meals', FALSE),
       (7, 'discussions', TRUE),
       (7, 'joint joggings', FALSE),
       (7, 'meetings', FALSE),
       (8, 'to the church', FALSE),                            -- James goes ............. every day.
       (8, 'playing basketball', FALSE),
       (8, 'jogging', TRUE),
       (8, 'shopping', FALSE),
       (8, 'to the toilet', FALSE),
       (9, 'before', FALSE),                                   -- He hopes to return to Manchester ............. Easter.
       (9, 'at', FALSE),
       (9, 'after', TRUE),
       (9, 'next year before', FALSE),
       (9, 'next year after', FALSE),
       (10, 'post office', FALSE),                             -- At Easter, James is going to work at a .............
       (10, 'construction', FALSE),
       (10, 'farm', TRUE),
       (10, 'cinema', FALSE),
       (10, 'shopping center', FALSE),
       (11, 'a chocolate factory', FALSE),                     -- Bournville is .............
       (11, 'a river', FALSE),
       (11, 'a village', TRUE),
       (11, 'the founder of a chocolate factory', FALSE),
       (11, 'a chocolate bunny', FALSE),
       (12, 'it was close to farms which provided milk',
        FALSE),                                                -- The new site for the chocolate factory was chosen because .............
       (12, 'it was easy to build there', FALSE),
       (12, 'it was close to several transportation routes', TRUE),
       (12, 'a lot of people lived nearby.', FALSE),
       (12, 'it was in the centre of the city', FALSE),
       (13, 'a local town', FALSE),                            -- Bournville takes its name from .............
       (13, 'a French town', FALSE),
       (13, 'a local river and a French word', TRUE),
       (13, 'a kind of French chocolate', FALSE),
       (13, 'a local river', FALSE),
       (14, 'free for workers', FALSE),                        -- The original houses in Bournville were .............
       (14, 'large', FALSE),
       (14, 'traditional in appearance', TRUE),
       (14, 'built by the factory workers', FALSE),
       (14, 'had no garden', FALSE),
       (15, 'financial social support', FALSE),                -- Workers at the Cadbury received .............
       (15, 'free health care', FALSE),
       (15, 'pensions', TRUE),
       (15, 'dancing lessons', FALSE),
       (15, 'free food and drink', FALSE),
       (16, 'sporty', FALSE),                                  -- The extract shows that the Cadbury family were .............
       (16, 'careful', FALSE),
       (16, 'kind', TRUE),
       (16, 'mean', FALSE),
       (16, 'lazy', FALSE),
       (17, 'First-time buyers', FALSE),                       -- ............. can live in special homes in Bournville.
       (17, 'Single people', FALSE),
       (17, 'People with learning problems', TRUE),
       (17, 'Chocolate factory workers', FALSE),
       (17, 'Poor people', FALSE),
       (18, 'billiard tables', FALSE),                         -- The Cadbury family added a park for the workers, which had .............
       (18, 'a golf course', FALSE),
       (18, 'a fishing lake', TRUE),
       (18, 'a diving pool', FALSE),
       (18, 'several basketball courts', FALSE),
       (19, 'cheap', FALSE),                                   -- In the Cadbury’s opinion alcohol was .............
       (19, 'hard to get', FALSE),
       (19, 'unhealthy', TRUE),
       (19, 'made by Satan', FALSE),
       (19, 'a luxury item', FALSE),
       (20, 'pub', FALSE),                                     -- The workers could have dinner in the .............
       (20, 'factory', FALSE),
       (20, 'clubhouse', TRUE),
       (20, 'community centre', FALSE),
       (20, 'restaurant', FALSE),
       (21, 'The chief', FALSE),                               -- ............. was/were discovered in a park in Lechlade, UK.
       (21, 'The old man', FALSE),
       (21, 'Both the chief and the old man', TRUE),
       (21, 'Chiefs from the Beaker culture', FALSE),
       (21, 'Important members of the Beaker culture', FALSE),
       (22, 'Both the chief and the old man',
        FALSE),                                                -- ............. was/were buried with the heads and hooves of four cattle.
       (22, 'The old man', FALSE),
       (22, 'The chief', TRUE),
       (22, 'Chiefs from the Beaker culture', FALSE),
       (22, 'Important members of the Beaker culture', FALSE),
       (23, 'Journalists', FALSE),                             -- ............. believe that the cattle were sacrificed.
       (23, 'Scientists', FALSE),
       (23, 'Archaeologists', TRUE),
       (23, 'British people', FALSE),
       (23, 'Local people', FALSE),
       (24, 'The old man', FALSE),                             -- ............. was/were buried with a beaker.
       (24, 'The chief', FALSE),
       (24, 'Important members of the Beaker culture', TRUE),
       (24, 'Chiefs from the Beaker culture', FALSE),
       (24, 'Both the chief and the old man', FALSE),
       (25, 'Chiefs from the Beaker culture', FALSE),          -- ............. was/were not buried with a beaker.
       (25, 'Both the chief and the old man', FALSE),
       (25, 'The chief', TRUE),
       (25, 'Important members of the Beaker culture', FALSE),
       (25, 'The old man', FALSE),
       (26, 'The chief', FALSE),                               -- ............. was/were buried in a circular pit.
       (26, 'The old man', FALSE),
       (26, 'Both the chief and the old man', TRUE),
       (26, 'Important members of the Beaker culture', FALSE),
       (26, 'Chiefs from the Beaker culture', FALSE),
       (27, 'Scientists', FALSE),                              -- ............. thought the old man was a religious figure.
       (27, 'Archaeologists', FALSE),
       (27, 'Journalists', TRUE),
       (27, 'Local people', FALSE),
       (27, 'British people', FALSE),
       (28, 'Local people', FALSE),                            -- ............. believe that the old man was sacrificed.
       (28, 'Scientists', FALSE),
       (28, 'Journalists', TRUE),
       (28, 'British people', FALSE),
       (28, 'Archaeologists', FALSE),
       (29, 'Important members of the Beaker culture', FALSE), -- ............. was/were buried in a sitting position.
       (29, 'Chiefs from the Beaker culture', FALSE),
       (29, 'The old man', TRUE),
       (29, 'Both the chief and the old man', FALSE),
       (29, 'The chief', FALSE),
       (30, 'The chief', FALSE),                               -- ............. was/were buried with a dagger in most cases.
       (30, 'The old man', FALSE),
       (30, 'Members of the Beaker culture', TRUE),
       (30, 'Both the chief and the old man', FALSE),
       (30, 'Chiefs from the Beaker culture', FALSE);

INSERT INTO english_language_essay_topic(difficulty_id, topic)
VALUES (1, 'Describe your home! How does it look like from outside, rooms, what is in the rooms, etc.'),
       (2, 'Write your opinion about the role of physical education in the school system.'),
       (3, 'Should the death sentence be implemented globally? Write an essay about this topic!');

INSERT INTO social_situation_type(type)
VALUES ('image'),
       ('video');

INSERT INTO social_situation_media(title, url, type_id)
VALUES ('Iskolai jegyzetek', 'https://www.youtube.com/watch?v=uSliv0T9Zxg', 2),
       ('Paintballozás', 'https://www.youtube.com/watch?v=bkhE-SMh1-Q', 2),
       ('Csoportos beszélgetés összejövetelen', '../static/img/img01.png', 1),
       ('A bor baleset', '../static/img/img02.png', 1),
       ('Klikkesedés', '../static/img/img03.png', 1),
       ('Pletyka a kórházban', '../static/img/img04.png', 1),
       ('Nemi megkülönböztetés', '../static/img/img05.png', 1);

INSERT INTO social_situation_question(question, media_id)
VALUES ('Miért reagálnak úgy ahogy?', 1),
       ('Voltál-e már hasonló szituációban? Mit csináltál?', 1),
       ('Mit éreztél?', 1),
       ('Hogyan jellemeznéd ezt a szituációt?', 2),
       ('Mit éreztél? Hogyan reagáltál?', 3),
       ('Mit tennél egy ilyen helyzetben?', 4),
       ('Hogyan írnád le a légkört?', 5),
       ('Hogy alakulhat ki egy ilyen szituáció?', 5),
       ('Mit csinálnak éppen a képen látható emberek?', 6),
       ('Mi történik a képen?', 7),
       ('Mit éreztél?', 7);
