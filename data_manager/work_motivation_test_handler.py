from typing import TYPE_CHECKING

from connection import connection_handler
from data_manager import data_handler_util

if TYPE_CHECKING:
    pass


# region --------------------------------------READ-----------------------------------------

@connection_handler
def get_questions(cursor: 'Cursor') -> list[dict]:
    query = """
    SELECT id, title
    FROM work_motivation_question
    ORDER BY id
    """
    cursor.execute(query)
    return cursor.fetchall()


# endregion
# region ---------------------------------------WRITE----------------------------------------
@connection_handler
def submit_answer(cursor: 'Cursor', answers: dict, user_id: int) -> None:
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
