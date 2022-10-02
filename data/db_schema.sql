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
DROP TABLE IF EXISTS english_language_result_essay CASCADE;
DROP TABLE IF EXISTS english_language_result CASCADE;

CREATE TABLE language
(
    hu VARCHAR PRIMARY KEY,
    en VARCHAR
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
    FOREIGN KEY (text_id) REFERENCES english_language_text (id) ON DELETE CASCADE
);

CREATE TABLE english_language_option
(
    id          SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL,
    option      VARCHAR NOT NULL,
    correct     BOOLEAN NOT NULL,
    FOREIGN KEY (question_id) REFERENCES english_language_question (id) ON DELETE CASCADE
);

CREATE TABLE english_language_result_essay
(
    id        SERIAL PRIMARY KEY,
    result_id INTEGER NOT NULL,
    essay     VARCHAR(2000),
    FOREIGN KEY (result_id) REFERENCES result_header (id) ON DELETE CASCADE
);

CREATE TABLE english_language_result
(
    id        SERIAL PRIMARY KEY,
    option_id INTEGER NOT NULL,
    result_id INTEGER NOT NULL,
    FOREIGN KEY (option_id) REFERENCES english_language_option (id),
    FOREIGN KEY (result_id) REFERENCES result_header (id)
);



INSERT INTO language(hu, en)
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
       ('Elérhető tesztek','Available tests');


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
VALUES ( 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam malesuada sit amet nisl at dignissim. In dapibus eros id felis interdum, non laoreet magna venenatis. Suspendisse a nisl sodales, luctus neque ac, dictum nunc. Fusce vestibulum at eros mattis convallis. Nam metus neque, accumsan nec ipsum eu, tempor consequat turpis. Nam pretium posuere nunc. Fusce mattis enim enim, ac bibendum augue accumsan sed. Nulla facilisi. Integer tempus lacus felis, quis varius elit gravida bibendum. In hac habitasse platea dictumst. Ut quis nunc suscipit, tempus purus id, scelerisque arcu. Sed et tortor et elit consequat pretium. Duis ornare mi vel augue efficitur, in tristique dui pulvinar. Praesent placerat nibh eget sodales luctus.

Phasellus eget elit sed justo finibus scelerisque at sed nunc. Etiam vitae felis eget risus varius elementum. Vestibulum vulputate, odio sit amet porttitor malesuada, mi velit blandit ex, ac molestie est velit eu turpis. Mauris tincidunt orci dui, ac tempor felis varius a. In efficitur gravida lorem, vitae luctus tellus faucibus placerat. Quisque mauris augue, eleifend vel erat in, faucibus ullamcorper nunc. Nullam feugiat metus eget cursus ultrices. Morbi nunc erat, congue eu ante et, porta maximus felis. Vestibulum pharetra feugiat neque, porta sagittis elit maximus ac. Sed laoreet ac felis at pellentesque. Proin id iaculis ligula. Aliquam lobortis pretium libero, quis cursus lacus pretium eu. Fusce nec auctor tortor, et molestie turpis. Curabitur at lacus sed augue rhoncus euismod. Quisque venenatis, nisi sit amet tristique tempor, nisl ipsum posuere velit, at elementum turpis ipsum at quam. Sed rutrum sodales dolor vel semper.

Aenean commodo, mauris ac tincidunt viverra, tortor odio finibus quam, vel convallis orci dui vel urna. Phasellus sed felis lectus. Aenean congue euismod orci, ut mattis mi molestie in. Maecenas a magna non nisi commodo cursus et at nunc. Proin ultricies tellus non commodo euismod. Sed et mi at neque fringilla molestie id quis diam. Phasellus ac sollicitudin quam. Integer ornare vitae ex vitae ornare. Nullam vel justo ac nisl suscipit tincidunt.

Morbi mattis elit et velit egestas volutpat. Aliquam vitae dui tincidunt, tempor lorem vitae, laoreet leo. Mauris ipsum odio, vehicula sit amet sagittis nec, faucibus non sapien. Nullam malesuada turpis nec semper consequat. Integer leo dolor, tristique eget justo ut, blandit interdum lacus. Curabitur mollis blandit mauris ut volutpat. Proin ac quam rhoncus, tincidunt metus in, porttitor tortor.

Duis et nulla mi. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed tincidunt lacus eget justo rutrum, quis condimentum ante rhoncus. Sed vitae justo eget ligula fringilla ullamcorper sed nec risus. Curabitur vestibulum blandit erat, vitae gravida sem luctus id. Aliquam fringilla tellus sodales sapien consectetur, quis fringilla diam varius. Quisque at porta justo. Mauris nec pulvinar lectus. Duis malesuada metus ut tortor porttitor ultricies vel eget eros. Mauris tellus arcu, ornare nec malesuada id, suscipit at felis.'
       , 1),
       ( 'Lorem ipsum dolor sit amet consectetur, adipiscing elit nam potenti, fames tristique eu nascetur blandit, curae sem commodo. Suscipit eleifend vestibulum mattis mauris blandit nec morbi vehicula urna, conubia ligula nullam netus consectetur dolor mus ullamcorper, dignissim sem dui nostra dis condimentum posuere consequat. Id consectetur turpis porta at elementum cubilia euismod rutrum, nostra auctor habitant malesuada cursus ac cum sit faucibus, morbi suspendisse cras urna commodo sociis rhoncus. Nostra sed elementum cubilia nibh pharetra pretium phasellus lectus in nec, consectetur id dis suscipit viverra congue hendrerit ultricies senectus. Fames suscipit nunc quisque eros iaculis leo adipiscing, cras pharetra nec cum phasellus libero vehicula, natoque morbi diam vitae vulputate accumsan.

Eleifend scelerisque id aliquam laoreet pharetra erat parturient suscipit, netus mollis eros potenti dui non porttitor facilisis, ante montes volutpat viverra vulputate elit quis. Volutpat suscipit ullamcorper semper at nulla nunc magna eget placerat cum, pharetra ad sollicitudin porta curae felis dis ligula diam. Velit parturient tempor class justo ultrices ipsum fusce nunc fames facilisi facilisis, donec mus pretium praesent ad turpis ante viverra nibh sem, fermentum lobortis dui venenatis molestie vulputate mattis cursus consectetur lacus. Orci himenaeos metus curae facilisis est sapien cursus primis, commodo nunc euismod taciti aenean dapibus porta mi pretium, ac porttitor erat dictum cubilia aliquet pellentesque.

Elementum fames feugiat laoreet maecenas suspendisse tincidunt integer habitant nam, ligula id morbi rutrum dis malesuada sagittis magna, rhoncus tristique congue condimentum ullamcorper proin lobortis eget. Dis dignissim accumsan phasellus tristique ornare vulputate amet nostra proin ultrices quisque, massa laoreet montes sociis neque integer nec condimentum diam vel faucibus vivamus, sit elit scelerisque pellentesque maecenas gravida luctus eleifend ipsum nunc. Dui euismod dolor sollicitudin taciti ad ligula arcu dictum ridiculus, hac non cursus lectus aliquet adipiscing ante parturient et, justo quis velit felis vel pellentesque vehicula massa. Amet et tristique facilisi eros placerat adipiscing himenaeos convallis ad vivamus nostra non velit montes, hac feugiat cubilia accumsan cras laoreet vehicula faucibus volutpat imperdiet mauris at vitae. Quisque sem placerat eu amet erat ullamcorper sit laoreet habitant, gravida feugiat mi tempus netus elit nascetur consequat metus dapibus, mollis cras per bibendum potenti volutpat cursus hac.

Vulputate fermentum suscipit ligula sociosqu penatibus sapien bibendum dignissim in cubilia malesuada sem ac, ipsum integer nullam commodo ullamcorper volutpat ridiculus scelerisque suspendisse non inceptos viverra. Sapien nunc nostra id fringilla fusce maecenas lacinia quam imperdiet tincidunt, est primis dictumst consequat mi aptent sociis potenti platea. Dui proin vel scelerisque venenatis nullam luctus ad, nunc bibendum pretium aliquam fermentum diam, potenti laoreet libero sit platea hac. Ad praesent hac volutpat nulla sit ornare vulputate, eget dignissim in a ullamcorper massa. Adipiscing cras quisque parturient vivamus aliquam sed phasellus nam aptent primis himenaeos, class sapien ipsum quis posuere viverra montes dignissim metus suscipit, natoque id ridiculus hendrerit blandit litora ullamcorper nostra pretium imperdiet.'
       , 2),
       ( 'Lorem ipsum dolor sit amet consectetur adipiscing elit tristique lectus curae, non facilisi dictumst mollis pharetra nec cum sociis. Parturient imperdiet turpis eu fames bibendum class porta euismod, ipsum tempor velit platea nascetur a fermentum litora dolor, pulvinar vel adipiscing porttitor vulputate interdum enim. Augue semper massa mollis imperdiet suscipit tortor orci ornare risus neque potenti, congue leo nisl consectetur penatibus feugiat fames ullamcorper curabitur a justo, magnis vulputate vestibulum mus dictumst ultrices tristique eu torquent elementum. Eget tristique sapien felis leo elit litora habitasse elementum congue vitae, mattis venenatis diam orci nec urna nisi netus ligula magna, convallis fusce dictum metus ullamcorper quisque arcu torquent mauris. Mollis sollicitudin nam augue sociis fringilla curae nibh faucibus, nullam fusce ullamcorper lorem curabitur aliquet a litora penatibus, cum sem velit hendrerit nostra egestas integer. Class leo lobortis cursus dui donec ultrices condimentum cum non, dictumst est pulvinar malesuada magnis mi ridiculus suspendisse aenean parturient, vestibulum venenatis ut nisi dolor nascetur ornare curabitur.

Magnis parturient nostra ligula eu cras ullamcorper, in ultricies a cum et curae, risus ut etiam dictumst magna. Etiam cum donec congue metus aliquam dictum, amet neque ligula consequat ornare, fermentum vulputate maecenas placerat ultricies. Cursus senectus dolor leo nullam potenti magna, ad himenaeos phasellus maecenas mus a ut, fermentum sagittis risus litora accumsan. Urna phasellus ridiculus conubia eleifend felis bibendum dui a aliquam, massa scelerisque diam posuere molestie aenean vel leo habitasse, nam sociis ultrices turpis torquent himenaeos quam senectus. Nec consectetur vehicula netus praesent ad sociosqu fames ante lorem tempus mi, posuere dictumst habitant ultrices quisque suscipit morbi ornare scelerisque. Lacinia faucibus fringilla eleifend magnis dui ultricies phasellus viverra, justo porta in commodo lobortis rhoncus vel tortor, ante senectus orci ipsum fusce natoque purus. Hac metus primis leo litora consequat rhoncus placerat purus consectetur, mattis quisque cursus adipiscing proin dui porttitor natoque, facilisi justo nullam elementum urna vel lacinia dis. Lorem adipiscing conubia porttitor pellentesque donec bibendum nibh cubilia torquent, venenatis lacus suscipit egestas lacinia potenti nunc tellus aliquam velit, litora quam pharetra sed ipsum facilisis cursus sociosqu.

Ante dignissim arcu suspendisse donec ultricies, elit accumsan himenaeos feugiat, vulputate neque orci venenatis. Pretium non tortor a mus magnis sociosqu dolor praesent dapibus ultricies augue vulputate, hendrerit integer lobortis penatibus curabitur primis ut class elit duis. Nisi erat hac sem nam curabitur faucibus rutrum diam, tempus odio vel posuere nisl etiam suscipit nullam, habitasse feugiat quam facilisi lectus est vulputate. Sapien congue turpis pulvinar non facilisi consectetur aliquam, eget lobortis vitae fusce potenti dui feugiat purus, orci ante tempus fermentum dapibus massa. Vehicula imperdiet porttitor senectus magna consequat sem litora fusce ante placerat natoque tellus, est nunc conubia suspendisse tempor auctor netus velit a viverra enim varius nullam, nibh bibendum fermentum fames vitae proin inceptos tincidunt phasellus molestie lacinia. Mattis congue nisi suspendisse non ornare vulputate sociosqu penatibus, nullam dignissim pulvinar integer convallis justo risus, dolor feugiat sem ultrices netus platea aptent. Nunc proin torquent hendrerit donec ullamcorper sem senectus hac, lobortis facilisis tempus interdum amet suspendisse libero bibendum aenean, cras dolor nibh parturient elit scelerisque netus. Luctus nibh mattis himenaeos sociosqu ultricies at conubia habitasse lacus parturient libero senectus auctor rutrum placerat, dignissim molestie integer phasellus imperdiet rhoncus mi ultrices vestibulum viverra diam lobortis ad nam.

Aliquam luctus tempor mattis donec ultricies ad tortor tincidunt, interdum scelerisque nisl risus nam venenatis arcu phasellus ut, etiam lorem hendrerit eu eget praesent proin. Commodo leo dictumst mauris quam cum erat torquent, potenti viverra sodales convallis tristique ut urna vitae, parturient porttitor blandit habitant nec sem. Tellus aliquam tristique sed vitae cum facilisis in, etiam gravida senectus dis urna primis ante inceptos, vestibulum auctor litora pharetra semper molestie. Fringilla enim nisi torquent turpis sed cursus adipiscing vel primis, aliquet urna elit porta magna feugiat egestas in ac, accumsan sit maecenas varius odio eleifend pulvinar mauris. Vehicula ultrices malesuada venenatis potenti porta quam ipsum suscipit nascetur consectetur, lacus facilisi donec lobortis semper taciti duis imperdiet nec, egestas est dui metus mauris vulputate cras integer orci. Dictumst metus nibh a egestas primis magna leo, tellus mi facilisis cubilia aliquet suscipit malesuada, massa at accumsan ultricies maecenas potenti.'
       , 3);

INSERT INTO english_language_question(text_id, question)
VALUES (1, 'Question 1'),
       (1, 'Question 2'),
       (1, 'Question 3'),
       (1, 'Question 4'),
       (1, 'Question 5'),
       (1, 'Question 6'),
       (1, 'Question 7'),
       (1, 'Question 8'),
       (1, 'Question 9'),
       (1, 'Question 10'),
       (2, 'Question 1'),
       (2, 'Question 2'),
       (2, 'Question 3'),
       (2, 'Question 4'),
       (2, 'Question 5'),
       (2, 'Question 6'),
       (2, 'Question 7'),
       (2, 'Question 8'),
       (2, 'Question 9'),
       (2, 'Question 10'),
       (3, 'Question 1'),
       (3, 'Question 2'),
       (3, 'Question 3'),
       (3, 'Question 4'),
       (3, 'Question 5'),
       (3, 'Question 6'),
       (3, 'Question 7'),
       (3, 'Question 8'),
       (3, 'Question 9'),
       (3, 'Question 10');

INSERT INTO english_language_option(question_id, option, correct)
VALUES (1, 'Option 1', FALSE),
       (1, 'Option 2', FALSE),
       (1, 'Option 3', TRUE),
       (1, 'Option 4', FALSE),
       (1, 'Option 5', FALSE),
       (2, 'Option 1', FALSE),
       (2, 'Option 2', FALSE),
       (2, 'Option 3', TRUE),
       (2, 'Option 4', FALSE),
       (2, 'Option 5', FALSE),
       (3, 'Option 1', FALSE),
       (3, 'Option 2', FALSE),
       (3, 'Option 3', TRUE),
       (3, 'Option 4', FALSE),
       (3, 'Option 5', FALSE),
       (4, 'Option 1', FALSE),
       (4, 'Option 2', FALSE),
       (4, 'Option 3', TRUE),
       (4, 'Option 4', FALSE),
       (4, 'Option 5', FALSE),
       (5, 'Option 1', FALSE),
       (5, 'Option 2', FALSE),
       (5, 'Option 3', TRUE),
       (5, 'Option 4', FALSE),
       (5, 'Option 5', FALSE),
       (6, 'Option 1', FALSE),
       (6, 'Option 2', FALSE),
       (6, 'Option 3', TRUE),
       (6, 'Option 4', FALSE),
       (6, 'Option 5', FALSE),
       (7, 'Option 1', FALSE),
       (7, 'Option 2', FALSE),
       (7, 'Option 3', TRUE),
       (7, 'Option 4', FALSE),
       (7, 'Option 5', FALSE),
       (8, 'Option 1', FALSE),
       (8, 'Option 2', FALSE),
       (8, 'Option 3', TRUE),
       (8, 'Option 4', FALSE),
       (8, 'Option 5', FALSE),
       (9, 'Option 1', FALSE),
       (9, 'Option 2', FALSE),
       (9, 'Option 3', TRUE),
       (9, 'Option 4', FALSE),
       (9, 'Option 5', FALSE),
       (10, 'Option 1', FALSE),
       (10, 'Option 2', FALSE),
       (10, 'Option 3', TRUE),
       (10, 'Option 4', FALSE),
       (10, 'Option 5', FALSE),
       (11, 'Option 1', FALSE),
       (11, 'Option 2', FALSE),
       (11, 'Option 3', TRUE),
       (11, 'Option 4', FALSE),
       (11, 'Option 5', FALSE),
       (12, 'Option 1', FALSE),
       (12, 'Option 2', FALSE),
       (12, 'Option 3', TRUE),
       (12, 'Option 4', FALSE),
       (12, 'Option 5', FALSE),
       (13, 'Option 1', FALSE),
       (13, 'Option 2', FALSE),
       (13, 'Option 3', TRUE),
       (13, 'Option 4', FALSE),
       (13, 'Option 5', FALSE),
       (14, 'Option 1', FALSE),
       (14, 'Option 2', FALSE),
       (14, 'Option 3', TRUE),
       (14, 'Option 4', FALSE),
       (14, 'Option 5', FALSE),
       (15, 'Option 1', FALSE),
       (15, 'Option 2', FALSE),
       (15, 'Option 3', TRUE),
       (15, 'Option 4', FALSE),
       (15, 'Option 5', FALSE),
       (16, 'Option 1', FALSE),
       (16, 'Option 2', FALSE),
       (16, 'Option 3', TRUE),
       (16, 'Option 4', FALSE),
       (16, 'Option 5', FALSE),
       (17, 'Option 1', FALSE),
       (17, 'Option 2', FALSE),
       (17, 'Option 3', TRUE),
       (17, 'Option 4', FALSE),
       (17, 'Option 5', FALSE),
       (18, 'Option 1', FALSE),
       (18, 'Option 2', FALSE),
       (18, 'Option 3', TRUE),
       (18, 'Option 4', FALSE),
       (18, 'Option 5', FALSE),
       (19, 'Option 1', FALSE),
       (19, 'Option 2', FALSE),
       (19, 'Option 3', TRUE),
       (19, 'Option 4', FALSE),
       (19, 'Option 5', FALSE),
       (20, 'Option 1', FALSE),
       (20, 'Option 2', FALSE),
       (20, 'Option 3', TRUE),
       (20, 'Option 4', FALSE),
       (20, 'Option 5', FALSE),
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
