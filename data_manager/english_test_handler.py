from connection import connection_handler


@connection_handler
def get_random_english_test_by_difficulty_id(cursor, difficulty_id) -> dict[dict,list[dict],list[dict],dict]:
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
    test["text"] = text
    test["questions"] = questions
    test["options"] = options
    test["essay_topic"] = essay_topic
    return test
