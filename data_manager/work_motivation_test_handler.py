from connection import connection_handler
from data_manager import data_handler_util


# region --------------------------------------READ-----------------------------------------

@connection_handler
def get_questions(cursor) -> list[dict]:
    query = """
    SELECT id, title
    FROM work_motivation_question
    ORDER BY id
    """
    cursor.execute(query)
    return cursor.fetchall()


@connection_handler
def get_results_for_applicant(cursor, username) -> list[dict]:
    query = """
    SELECT wmc.title, SUM(wmr.score) as cat_score
    FROM work_motivation_result wmr
    JOIN work_motivation_question wmq on wmr.question_id = wmq.id
    JOIN work_motivation_category wmc on wmq.category_id = wmc.id
    JOIN result_header rh on wmr.result_header_id = rh.id
    JOIN users u on u.id = rh.user_id
    WHERE u.username LIKE %s
    GROUP BY  wmc.title, u.username, wmc.id
    ORDER BY wmc.id
    """
    cursor.execute(query, (username,))
    return cursor.fetchall()


@connection_handler
def get_categories_max_points(cursor) -> list[dict]:
    query = """
    SELECT wmc.title, COUNT(wmq.*) * 5 AS max_point
    FROM work_motivation_category wmc
    JOIN work_motivation_question wmq on wmc.id = wmq.category_id
    GROUP BY wmc.title, wmc.id
    ORDER BY wmc.id
    """
    cursor.execute(query)
    return cursor.fetchall()


@connection_handler
def get_latest_completion_date_by_username(cursor, username) -> list[dict]:
    query = """
        SELECT rh.date
        FROM work_motivation_result wmr
        JOIN result_header rh on wmr.result_header_id = rh.id
        JOIN users u on u.id = rh.user_id
        WHERE u.username LIKE %s
        ORDER BY rh.date DESC
        LIMIT 1
        """
    cursor.execute(query, (username,))
    return cursor.fetchone()


# endregion
# region ---------------------------------------WRITE----------------------------------------
@connection_handler
def submit_answer(cursor, answers, user_id) -> None:
    result_header_id = data_handler_util.add_test_to_result_header(cursor, user_id)
    query = """
    INSERT INTO work_motivation_result(question_id, result_header_id, score) VALUES"""
    for _ in answers:
        query += " (%s, %s, %s),"
    query = query[:-1]
    var = []
    for question_id, score in answers.items():
        var.extend([question_id, result_header_id, score])
    cursor.execute(query, var)


@connection_handler
def patch_title_by_id(cursor, question_id, title):
    query = """
    UPDATE work_motivation_question
    SET title = %s
    WHERE id = %s
    """
    var = (title, question_id)
    cursor.execute(query, var)

# endregion
