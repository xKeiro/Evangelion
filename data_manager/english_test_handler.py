import random
from typing import TYPE_CHECKING

from connection import connection_handler
from data_manager import data_handler_util

if TYPE_CHECKING:
    from psycopg import Cursor


# region --------------------------------------READ-----------------------------------------
@connection_handler
def get_random_english_test_by_difficulty_id(cursor: 'Cursor', difficulty_id: int) -> dict[
    dict, list[dict], list[dict], dict]:
    query = """
SELECT ARRAY [elt.id::VARCHAR, elt.text]                                                 AS "text",
       ARRAY_AGG(DISTINCT ARRAY [elq.id::VARCHAR, elq.question])                         AS questions,
       ARRAY_AGG(DISTINCT ARRAY [elo.id::VARCHAR, elo.question_id::VARCHAR, elo.option]) AS "options",
       (SELECT ARRAY [elet.id::VARCHAR, elet.topic]
        FROM english_language_essay_topic elet
        WHERE elet.difficulty_id = elt.difficulty_id
        ORDER BY RANDOM()
        LIMIT 1) AS essay_topic
FROM english_language_text elt
         LEFT JOIN english_language_question elq ON elt.id = elq.text_id
         LEFT JOIN english_language_option elo ON elq.id = elo.question_id
WHERE elt.difficulty_id = %s
GROUP BY elt.id
ORDER BY RANDOM()
LIMIT 1
    """
    var = (difficulty_id,)
    cursor.execute(query, var)
    test = cursor.fetchone()
    text = {"id": int(test["text"][0]), "text": test["text"][1]}
    questions = [{"id": int(question[0]), "question": question[1]} for question in
                 test["questions"]]
    options = [{"id": int(option[0]), "question_id": int(option[1]), "option": option[2]} for option in
               test["options"]]
    essay_topic = {"id": int(test["essay_topic"][0]), "topic": test["essay_topic"][1]}
    random.shuffle(questions)
    random.shuffle(options)
    test["text"] = text
    test["questions"] = questions
    test["options"] = options
    test["essay_topic"] = essay_topic
    return test


@connection_handler
def get_all_english_reading_comprehension_test_by_difficulty_id(cursor: 'Cursor', difficulty_id: int) -> list[
    dict[dict, list[dict], list[dict]]]:
    query = """
SELECT ARRAY [elt.id::VARCHAR, elt.text]                                                 AS "text",
       ARRAY_AGG(DISTINCT ARRAY [elq.id::VARCHAR, elq.question])                         AS questions,
       ARRAY_AGG(DISTINCT ARRAY [elo.id::VARCHAR, elo.question_id::VARCHAR, elo.option, elo.correct::VARCHAR]) AS "options"
FROM english_language_text elt
         LEFT JOIN english_language_question elq ON elt.id = elq.text_id
         LEFT JOIN english_language_option elo ON elq.id = elo.question_id
WHERE elt.difficulty_id = %s
GROUP BY elt.id
ORDER BY elt.id
    """
    var = (difficulty_id,)
    cursor.execute(query, var)
    tests = cursor.fetchall()
    for index, test in enumerate(tests):
        text = {"id": int(test["text"][0]), "text": test["text"][1]}
        questions = [{"id": int(question[0]), "question": question[1]} for question in
                     test["questions"]]
        options = [{"id": int(option[0]), "question_id": int(option[1]), "option": option[2], "correct": option[3]} for
                   option in
                   test["options"]]
        tests[index]["text"] = text
        tests[index]["questions"] = questions
        tests[index]["options"] = options
    return tests

@connection_handler
def get_all_english_essay_topic_by_difficulty_id(cursor: 'Cursor', difficulty_id: int) -> list[dict, dict]:
    query = """
    SELECT id, topic
    FROM english_language_essay_topic
    WHERE difficulty_id = %s
    ORDER BY id
    """
    var = (difficulty_id,)
    cursor.execute(query,var)
    essay_topics = cursor.fetchall()
    return essay_topics




# endregion
# region ---------------------------------------WRITE----------------------------------------

@connection_handler
def submit_result(cursor: 'Cursor', results: dict[list, dict], user_id: int) -> None:
    result_header_id = data_handler_util.add_test_to_result_header(cursor, user_id)
    query = """
    INSERT INTO english_language_result_essay(topic_id, result_header_id, essay)
    VALUES (%s, %s, %s);
    """
    var = (results["essay"]["topic_id"], result_header_id, results["essay"]["essay"])
    cursor.execute(query, var)
    query = "INSERT INTO english_language_result(option_id, result_id) VALUES"
    for _ in results["answers"]:
        query += " (%s, %s),"
    query = query[:-1]
    var = []
    for answer in results["answers"]:
        var.extend([answer, result_header_id])
    cursor.execute(query, var)


@connection_handler
def patch_text_by_id(cursor: 'Cursor', id: int, text: str) -> None:
    query = """
    UPDATE english_language_text
    SET text = %s
    WHERE id = %s
    """
    var = (text, id)
    cursor.execute(query, var)


@connection_handler
def patch_question_by_id(cursor: 'Cursor', question_id: int, question: str) -> None:
    query = """
    UPDATE english_language_question
    SET question = %s
    WHERE id = %s
    """
    var = (question, question_id)
    cursor.execute(query, var)


@connection_handler
def patch_option_by_id(cursor: 'Cursor', option_id: int, option: dict) -> None:
    query = """
    UPDATE english_language_option
    SET option = %s, correct= %s
    WHERE id = %s
    """
    var = (option["option"], option["correct"], option_id)
    print(type(cursor))
    cursor.execute(query, var)

@connection_handler
def patch_essay_topic_by_id(cursor: 'Cursor', id: int, topic: str) -> None:
    query = """
    UPDATE english_language_essay_topic
    SET topic = %s
    WHERE id = %s
    """
    var = (topic, id)
    cursor.execute(query, var)

# endregion
