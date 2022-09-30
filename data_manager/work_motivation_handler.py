from connection import connection_handler
# region --------------------------------------READ-----------------------------------------

@connection_handler
def get_questions(cursor) -> list[dict]:
    query = """
    SELECT id, title
    FROM work_motivation_question
    """
    cursor.execute(query)
    return cursor.fetchall()

# endregion
# region ---------------------------------------WRITE----------------------------------------
@connection_handler
def submit_answer(cursor, answers, username) -> None:
    query = """
    INSERT INTO result_header(username)
    VALUES (%s)
    RETURNING id;
    """
    var=(username,)
    cursor.execute(query,var)
    result_header_id = cursor.fetchone()["id"]

    query ="""
    INSERT INTO work_motivation_result(question_id, result_header_id, score) VALUES"""
    for _ in answers:
        query += " (%s, %s, %s),"
    query = query[:-1]
    var = []
    print(query)
    for question_id, score in answers.items():
        var.extend([question_id, result_header_id, score])
    cursor.execute(query,var)


# endregion
