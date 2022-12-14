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
    url     VARCHAR NOT NULL UNIQUE,
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
VALUES ('F??oldal', 'Home'),
       ('Kijelentkez??s', 'Logout'),
       ('Bejelentkez??s', 'Login'),
       ('Regisztr??ci??', 'Register'),
       ('Tesztek', 'Tests'),
       ('Bejelentkezve mint', 'Logged in as'),
       ('Felhaszn??l??n??v', 'Username'),
       ('Jelsz??', 'Password'),
       ('E-mail', 'E-mail'),
       ('Csal??dn??v', 'Last name'),
       ('Keresztn??v', 'First name'),
       ('Sz??let??si id??', 'Birthday'),
       ('Elk??ld??s', 'Submit'),
       ('D??tum', 'Date'),
       ('A bejelentkez??s sikertelen!', 'Login attempt failed!'),
       ('A felhaszn??l??n??v foglalt!', 'Username taken!'),
       ('K??rlek v??lassz egy m??sikat!', 'Please choose a new one!'),
       ('Ellen??rizd a felhaszn??l??neved ??s a jelszavad!', 'Check your username and password!'),
       ('Regisztr??ci?? sz??ks??ges ennek az oldalnak az el??r??s??hez!', 'Registration needed needed to access this site!'),
       ('V??laszok elk??ld??se', 'Send answers'),
       ('A teszted eredm??nye elk??ldve!', 'The result of your test has been submitted!'),
       ('K??rlek v??laszolj az ??sszes k??rd??sre elk??ld??s el??tt!',
        'Please answer all questions before sending your answers!'),
       ('??dv??z??llek Salva Vit??n', 'Welcome to Salva Vita'),
       ('El??rhet?? tesztek', 'Available tests'),
       ('Tov??bb az essz?? ??r??shoz!', 'Onward to the essay writing!'),
       ('Teszt elk??ld??se!', 'Send test!'),
       ('Biztos tov??bb szeretn??l l??pni?', 'Are you sure you want to continue?'),
       ('Probl??me volt az adatok elk??ld??s??vel, k??rlek pr??b??ld meg k??s??bb!',
        'There was a problem sending your data, please try again later!'),
       ('Nincs jogosults??god ennek az oldalnak az el??r??s??hez!',
        E'You don\'t have a necessary permission to access this site!'),
       ('Tov??bb a', 'To the'),
       ('tesztre', 'test'),
       ('Munka motiv??ci??', 'Work motivation'),
       ('Ennek a tesztnek a l??nyege, hogy felm??rje a hozz????ll??sodat a munk??hoz',
        'The purpose of this test is to asses your work attitude'),
       ('Angol nyelv', 'English Language'),
       ('Alapfok', 'Elementary'),
       ('Ez a teszt felm??ri az alapfok?? angol tud??sod', 'This test assesses your skills in elementary english'),
       ('K??z??pfok', 'Intermediate'),
       ('Ez a teszt felm??ri a k??z??pfok?? angol tud??sod', 'This test assesses your skills in intermediate english'),
       ('Fels?? k??z??pfok', 'Upper intermediate'),
       ('Ez a teszt felm??ri a fels?? k??z??pfok?? angol tud??sod',
        'This test assesses your skills in upper intermediate english'),
       ('Szoci??lis k??szs??gek', 'Social skills'),
       ('Vizu??lis ??szlel??si k??szs??gek', 'Visual perception skills'),
       ('Ebben a tesztben felm??rj??k a vizu??lis ??szlel??si k??pess??ged','In this test we assess your ability in visual perception'),
       ('Ebben a tesztben felm??rj??k a szoci??lis k??szs??geid','In this test we assess your social skills'),
       ('Teszt le??r??s', 'Test description'),
       ('Teszt kateg??ria', 'Test category'),
       ('Munka-motiv??ci??s k??rd??iv', 'Work motivation survey'),
       ('Tov??bb a teszthez', 'To the test'),
       ('Teszt eredm??nyek PDF', 'Test results PDF'),
       ('SOKSZ??N??S??G', 'DIVERSITY'),
       ('Meggy??z??d??s??nk, hogy a munkahelyek meg tudj??k v??ltoztatni a vil??got, ha elk??telez??dnek a soksz??n??s??g mellett. Gondoljunk csak bele, hogy t??bb mint 4,5 milli?? ember t??lti ??lete egyharmad??t a munkahely??n Magyarorsz??gon. K??pzelj??k el, mi t??rt??nne, ha itt megtanuln??nk egy??ttm??k??dni olyan emberekkel, akik k??l??nb??znek t??l??nk? Eg??szen biztos, hogy a munk??n k??v??li szavaink ??s tetteink is megv??ltozn??nak.',
        'We believe that workplaces can change the world if they commit to diversity. Just think, more than 4.5 million people spend a third of their lives at work in Hungary. Imagine what would happen if we learned to work with people here who are different from us? Our words and actions outside work would certainly change.'),
       ('MEGT??R??L??S', 'PAY-OFF'),
       ('Ma m??r szinte minden nagyv??llalat tudja, hogy a soksz??n??s??g j?? dolog, fontos dolog, hogy az a helyes, ha erre odafigyel??nk. De tapasztalataink szerint m??g nem minden v??llalat tudja, hogy gazdas??gilag is a soksz??n??s??g a racion??lis d??nt??s. Sz??mos kutat??s bizony??tja ugyanis, hogy a soksz??n?? c??gek, a val??ban befogad?? c??gek ??zleti eredm??nye jelent??s m??rt??kben meghaladja a t??bbi v??llalat??t.',
        'Today, almost every large company knows that diversity is a good thing, that it is important to do the right thing by paying attention to it. But in our experience, not all companies know that diversity is the rational economic choice. In fact, there is a lot of research showing that diverse companies, truly inclusive companies, significantly outperform other companies.'),
       ('BEFOGAD??S', 'INCLUSION'),
       ('A soksz??n??s??gi c??lkit??z??s ??nmag??ban azonban nem el??g. A befogad??sr??l nem el??g besz??lni, nem el??g sz??mokat kit??zni, azt m??velni kell, tenni kell ??rte. Ebben tud seg??teni a c??geknek a Salva Vita Alap??tv??ny tan??csad??ssal, szolg??ltat??sokkal, tr??ningekkel, v??llalati rendezv??nyekkel, munkaer?? k??zvet??t??s??vel, kiadv??nyokkal. Mi az??rt dolgozunk, k??zel 30 ??ve, hogy seg??ts??k a c??geket egy befogad?? munkak??rnyezet kialak??t??s??ban. Keress minket! Egy??tt. M??k??d??nk.',
        'But the diversity objective alone is not enough. Inclusion is not enough to talk about, it is not enough to set numbers, it must be cultivated, it must be acted upon. This is where the Salva Vita Foundation can help companies through advice, services, training, company events, recruitment, publications. We have been working for nearly 30 years to help companies create an inclusive working environment. Contact us! Together. We work.'),
       ('MEGTART??S', 'LOYALTY'),
       ('A megv??ltozott munkak??pess??g?? munkat??rsak egy megb??zhat?? ??s loj??lis munkav??llal??i k??rt alkotnak, akik produktivit??sa ??? az ??ltal??nos v??leked??sekkel ellent??tben ??? az ??tlagost??l nem t??r el, ??s hozz????ll??sukat tekintve elk??telezettebbek, loj??lisabbak a munk??ltat??juk ir??ny??ba.',
        'Disabled workers are a reliable and loyal group of employees who, contrary to common perceptions, are productive, not different from the average, and have a more committed and loyal attitude towards their employer.'),
       ('Ugr??s a f?? tartalomra!', 'Skip to main content!'),
       ('Salva Vita log??', 'Salva Vita logo'),
       ('Tov??bb az essz?? t??m??khoz!', 'Go to the essay topics!'),
       ('PDF kezel??s', 'Manage PDF'),
       ('PDF let??lt??s', 'Download PDF'),
       ('-t??l', 'from'),
       ('-ig', 'to'),
       ('Legal??bb 1 sz??r??t ??ll??ts be!', 'You must set at least 1 filter!'),
       ('Nincs ilyen felhaszn??l??!', 'There is no such user!'),
       ('Nincs ilyen e-mail c??m!', 'There is no such e-mail address!'),
       ('Egy p??ly??z?? legut??bbi eredm??nyei', 'One applicant''s latest results'),
       ('T??bb p??ly??z?? legut??bbi eredm??nyei', 'More applicants latest results');


INSERT INTO users(username, password, email, first_name, last_name, birthday, is_admin)
VALUES ('admin', '$2b$12$PVhM2DgrT9aH19ozic8v9u06tzb.Q2c9IE/qrJ4QvfyPdMlY3X9hS', 'admin@admin.hu', 'Pista', 'Kiss',
        '1990-01-01', TRUE), ---pw: asd
       ('test', '$2b$12$PVhM2DgrT9aH19ozic8v9u06tzb.Q2c9IE/qrJ4QvfyPdMlY3X9hS', 'test@test.hu', 'Pista', 'Kiss',
        '1990-01-01', FALSE); ---pw: asd


INSERT INTO work_motivation_category(title)
VALUES ('Szellemi ??szt??nz??s'),
       ('Altruizmus'),
       ('Anyagiak'),
       ('V??ltozatoss??g'),
       ('F??ggetlens??g'),
       ('Preszt??zs'),
       ('Eszt??tikum'),
       ('T??rsas kapcsolatok'),
       ('J??t??koss??g'),
       ('??n??rv??nyes??t??s'),
       ('Hierarchia'),
       ('Hum??n ??rt??kek'),
       ('Munkateljes??tm??ny'),
       ('Kreativit??s'),
       ('Ir??ny??t??s');

INSERT INTO work_motivation_question(title, category_id)
VALUES ('... sz??ntelen??l ??j, megoldatlan probl??m??kba ??tk??zik.', 1),
       ('... m??sokon seg??thet.', 2),
       ('... sok p??nzt keres.', 3),
       ('... v??ltozatos munk??t v??gezhet.', 4),
       ('... szabadon d??nthet a saj??t ter??let??n.', 5),
       ('... tekint??lyt szerezhet munk??j??val.', 6),
       ('... ak??r m??v??sz is lehet.', 7),
       ('... a t??bbiek k??z?? tartozik.', 8),
       ('... pillanatnyi kedve d??nti el, hogy mit csin??ljon.', 9),
       ('... megval??s??tja ??nmag??t.', 10),
       ('... tisztelheti a f??n??k??t.', 11),
       ('... tehet valamit a t??rsadalmi igazs??goss??g??rt.', 12),
       ('... nem besz??lhet mell??, mert csak j?? vagy rossz megold??sok l??teznek.', 13),
       ('... m??sokat ir??ny??that.', 15),
       ('... ??j elk??pzel??seket alak??that ki.', 14),
       ('... valami ??jat alkothat.', 14),
       ('... objekt??ven lem??rheti munk??ja eredm??ny??t.', 13),
       ('... vezet??je mindig helyesen d??nt.', 11),
       ('... olyat is csin??lhat, ami m??s szem??ben f??l??slegesnek t??nhet.', 9),
       ('... szebb?? teheti a vil??got.', 7),
       ('... ??n??ll?? d??nt??seket hozhat.', 5),
       ('... gondtalan ??letet biztos??that.', 3),
       ('... ??j gondolatokkal tal??lkozhat.', 1),
       ('... vezet??i k??pess??geire sz??ks??ge lehet.', 15),
       ('... siker??t vagy kudarc??t csak a k??vetkez?? nemzed??k d??ntheti el.', 12),
       ('... szem??lyes ??letst??lusa ??rv??nyes??lhet.', 10),
       ('... munkat??rsai egyben bar??tai is.', 8),
       ('... biztos lehet afel??l, hogy munk??j????rt a t??bbiek megbecs??lik.', 6),
       ('... nem kell minduntalan ugyanazt csin??lnia.', 4),
       ('... j??t tehet m??sok ??rdek??ben.', 2),
       ('... m??s emberek jav??t szolg??lhatja.', 2),
       ('... sokf??le dolgot csin??lhat.', 4),
       ('... (ember)re m??sok feln??znek.', 6),
       ('... j??l kij??n munkat??rsaival.', 8),
       ('... olyan ??letet ??lhet, amit legjobban szeret.', 10),
       ('... (ember)nek konfliktusokat kell v??llalnia.', 12),
       ('... m??sok munk??j??t is ir??ny??thatja.', 15),
       ('... szellemileg izgalmas munk??t v??gezhet.', 1),
       ('... magas nyugd??jra sz??m??that.', 3),
       ('... munk??j??ba m??snak nincs belesz??l??sa.', 5),
       ('... sz??pet teremthet.', 7),
       ('... olykor j??tszhat is.', 9),
       ('... (ember)nek meg??rt?? vezet??je van.', 11),
       ('... sz??ntelen??l fejlesztheti, t??k??letes??theti ??nmag??t.', 13),
       ('... ??j ??tleteire mindig sz??ks??g van.', 14);

INSERT INTO english_language_difficulty(title)
VALUES ('Elementary'),
       ('Intermediate'),
       ('Upper-intermediate');

INSERT INTO english_language_text(text, difficulty_id)
VALUES ( 'To: DomParsons@nitromail.com

From: JamesFSharp@bmail.net

Subject: Hi

Hi Dom,

How are you? I???m fine. I???m at home, of course, because of lockdown. I started my engineering course at Manchester University last year, but I???m not there now. I went to Manchester in October and I stayed in the student accommodation. We had lectures in the lecture rooms for three weeks, but after that, we had to stay in our accommodation because of Covid-19. I studied by computer. I wanted to go out to bars and join a basketball team, but I couldn???t. Luckily, there were some cool students in my accommodation. I made some good friends and we had cool parties.

But now I???m at home. I???m still studying by computer. I have four hours of lectures every day and then I work on projects. Actually, it???s quite good. We can do a lot of things by computer. I use different software programmes, read articles, and have discussions with the other students. I enjoy those discussions because I???m alone most of the time. Dad and mum are both at work all day. I can???t leave my town or visit friends, so I work! I work much harder than I did at school!

I miss playing basketball, but I???m keeping active. I go jogging once a day. But I???m watching a lot of videos too.

I???m not going to Manchester before Easter, but I hope to go there after Easter. In the Easter Holidays, I???m going to work on a friend???s farm in Wales. I don???t know anything about farming, but it will be great to be somewhere different!

Hope you are well,

from James.'
       , 1),
       ( 'If you love chocolate, maybe you have eaten a bar of Cadbury???s Bournville chocolate. But Bournville isn???t just the name of an English chocolate bar. It???s the name of a village which was built especially for workers at the Cadbury???s chocolate factory.
George and Richard Cadbury took over the cocoa and chocolate business from their father in 1861. A few years later, they decided to move the factory out of the centre of Birmingham, a city in the middle of England, to a new location where they could expand. They chose an area close to the railways and canals so that they could receive milk deliveries easily and send the finished products to stores across the country.

Here, the air was much cleaner than in the city centre, and the Cadbury brothers thought it would be a much healthier place for their employees to work. They named the site Bournville after a local river called ???The Bourn???. ???Ville???, the French word for town, was used because at the time, people thought French chocolate was the highest quality. The new factory opened in 1879. Close to it, they built a village where the factory workers could live. By 1900, there were 313 houses on the site, and many more were built later.

The Cadbury family were religious and believed that it was right to help other people. They thought their workers deserved to live and work in good conditions. In the factory, workers were given a fair wage, a pension and access to medical treatment. The village was also designed to provide the best possible conditions for workers too. The houses, although traditional in style, had modern interiors, indoor bathrooms and large gardens. The village provided everything that workers needed including a shop, a school and a community centre where evening classes were held to train young members of the workforce.

Since the Cadbury family believed that their workers and their families should be fit and healthy, they added a park with hockey and football pitches, a running track, bowling green, fishing lake, and an outdoor swimming pool. A large clubhouse was built in the park so that players could change their clothes and relax after a game. Dances and dinners were also held here for the factory workers, who were never charged to use any of the sports facilities. However, because the Cadbury???s believed that alcohol was bad for health and society, no pubs were ever built in Bourneville!

The Cadbury brothers were among the first business owners to ensure that their workers had good standards of living. Soon, other British factory owners were copying their ideas by providing homes and communities for their workers designed with convenience and health in mind. Today, over 25,000 people live in Bournville village. There are several facilities there to help people with special needs, such as care homes for the elderly, a hostel for people with learning difficulties and affordable homes for first-time homeowners and single people. Over a hundred years since the first house in Bournville Village was built, the aims of its founders are still carried out.'
       , 2),
       ( 'In 2017, archaeologists discovered the remains of a Bronze Age chief in Lechlade, a town in the west of England. The finding is historically interesting as the artefacts with which he was buried indicate that he was very important. Plus, the manner of his burial was significantly different from other burials at the time. Even more fascinating was the discovery of an older man???s remains close to the chief???s. Archaeologists are puzzling over what the relationship between the two men could be, and why they were treated so differently from the norm at the time.

Interestingly, the chief was buried with the heads and hooves of four cattle around 4,200 ago. Carbon dating has revealed that the remains, which were found in an area where a skate park is to be built, date back to the Bronze Age. Archaeologist Andy Hood, who helped to excavate the site, said that it was common for Bronze Age chiefs to be buried with the skull and hooves of a single cattle, but that until now none had been uncovered with multiple cattle remains in the UK. This fact seems to indicate that this chief was especially important. Hood and his colleagues consider it likely that the animals were killed as part of the burial ceremony. The loss of four of them would have been a considerable sacrifice.

Other artefacts found near the chief include a copper dagger, a stone wrist guard, a fire-making kit and some jewellery. These items were typically buried alongside members of the ???Beaker culture???. These were people who arrived in Britain from mainland Europe in around 2400BC. They were given this name due to the tall pots which looked like beakers that were typical of this culture. Usually, prominent people from this culture were buried with such a pot, but this chief was not. Archaeologists wonder whether this meant that this chief was especially revered among the Beaker society and was not symbolised by the typical pot.

The chieftain was buried at the centre of a circular pit. At the time, soil would have been piled on top of it. Near the chief, within the circle, were the remains of the older man, who was about 50-60 years old when he died. Newspapers have suggested that the older man was a priest who was sacrificed to help the chief in the afterlife. However, archaeologists say there is no evidence to support this idea. Even so, the older man???s burial is strange, as he was buried in an unusual seated position, with his legs going downwards into the earth. Bronze Age people, including the chief, were almost always buried on their sides. The reason for this unique position, the status of the chief and the relationship between the two men, may remain a mystery forever.'
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
       (2, 'In the Cadbury???s opinion alcohol was .............'),
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
       (2, '1', FALSE),                                        -- James went to lectures in the lecture rooms at Manchester university for ............. weeks.
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
       (12, 'it was close to farms which provided milk',FALSE), -- The new site for the chocolate factory was chosen because .............
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
       (19, 'cheap', FALSE),                                   -- In the Cadbury???s opinion alcohol was .............
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
       (22, 'Both the chief and the old man', FALSE),          -- ............. was/were buried with the heads and hooves of four cattle.
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
       (1, 'Is vaccination for everyone?'),
       (1, 'Does social media violate our privacy?'),
       (2, 'Does consumerism pose a big issue for the world?'),
       (2, 'Is vaping as harmful as smoking cigarettes?'),
       (2, 'Does our tax system benefit everyone fairly?'),
       (2, 'Is capital punishment ever justified?'),
       (3, 'Will people ever be able to live without the Internet?'),
       (3, 'Write your opinion about the role of physical education in the school system.'),
       (3, 'Should the death sentence be implemented globally? Write an essay about this topic!');

INSERT INTO social_situation_type(type)
VALUES ('image'),
       ('video');

INSERT INTO social_situation_media(title, url, type_id)
VALUES ('Iskolai jegyzetek', 'https://www.youtube.com/watch?v=uSliv0T9Zxg', 2),
       ('Paintballoz??s', 'https://www.youtube.com/watch?v=bkhE-SMh1-Q', 2),
       ('Csoportos besz??lget??s ??sszej??vetelen', '../static/img/img01.png', 1),
       ('A bor baleset', '../static/img/img02.png', 1),
       ('Klikkesed??s', '../static/img/img03.png', 1),
       ('Pletyka a k??rh??zban', '../static/img/img04.png', 1),
       ('Nemi megk??l??nb??ztet??s', '../static/img/img05.png', 1);

INSERT INTO social_situation_question(question, media_id)
VALUES ('Mi??rt reag??lnak ??gy ahogy?', 1),
       ('Volt??l-e m??r hasonl?? szitu??ci??ban? Mit csin??lt??l?', 1),
       ('Mit ??rezt??l?', 1),
       ('Hogyan jellemezn??d ezt a szitu??ci??t?', 2),
       ('Mit ??rezt??l? Hogyan reag??lt??l?', 3),
       ('Mit tenn??l egy ilyen helyzetben?', 4),
       ('Hogyan ??rn??d le a l??gk??rt?', 5),
       ('Hogy alakulhat ki egy ilyen szitu??ci???', 5),
       ('Mit csin??lnak ??ppen a k??pen l??that?? emberek?', 6),
       ('Mi t??rt??nik a k??pen?', 7),
       ('Mit ??rezt??l?', 7);
