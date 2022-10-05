from typing import TYPE_CHECKING
from connection import connection_handler
from data_manager import data_handler_util

if TYPE_CHECKING:
    from psycopg import Cursor


# region --------------------------------------READ-----------------------------------------
# @connection_handler
# def get_url_and_questions(cursor) -> list[dict]:
#     query = """
#     SELECT type, url, title, array_agg(question) AS questions, social_situation_question.id AS question_id
#     FROM (social_situation_type RIGHT JOIN social_situation_media ssm ON social_situation_type.id = ssm.type_id)
#         RIGHT JOIN social_situation_question ON social_situation_question.media_id = ssm.id
#     GROUP BY url, type, title, social_situation_question.id;
#     """
#     cursor.execute(query)
#     return cursor.fetchall()

@connection_handler
def get_situations(cursor:'Cursor') -> list[dict,list[dict]]:
    query = """
    SELECT ARRAY[sst.type, ssm.url, ssm.title, ssm.id::VARCHAR] AS media, ARRAY_AGG(ARRAY[ssq.id::VARCHAR, ssq.question]) AS questions
    FROM social_situation_media ssm
    JOIN social_situation_type sst ON ssm.type_id = sst.id
    JOIN social_situation_question ssq ON ssm.id = ssq.media_id
    GROUP BY ssm.id, sst.type, ssm.url, ssm.title
    ORDER BY sst.type, ssm.id
    """
    cursor.execute(query)
    situations = cursor.fetchall()
    for index, situation in enumerate(situations):
        media = {"type": situation["media"][0], "url": situation["media"][1], "title": situation["media"][2],
                 "id": int(situation["media"][3])}
        questions = [{"id": int(question[0]), "question": question[1]} for question in
                     situation["questions"]]
        situations[index]["media"] = media
        situations[index]["questions"] = questions
    return situations


@connection_handler
def get_situations_for_pdf_by_username(cursor, username):
    query = """
        SELECT ssm.title, ssq.question, ssr.answer
        FROM social_situation_result ssr
        JOIN result_header rh on ssr.result_id = rh.id
        JOIN social_situation_question ssq on ssr.question_id = ssq.id
        JOIN social_situation_media ssm on ssm.id = ssq.media_id
        JOIN users u on rh.user_id = u.id
        WHERE u.username LIKE %s AND rh.date =
            (SELECT rh.date
            FROM social_situation_result ssr
            JOIN result_header rh on ssr.result_id = rh.id
            JOIN social_situation_question ssq on ssr.question_id = ssq.id
            JOIN users u on rh.user_id = u.id
            WHERE u.username LIKE %s
            ORDER BY rh.date DESC, ssr.id
            LIMIT 1)
        ORDER BY rh.date DESC, ssr.id
        """
    cursor.execute(query, (username, username))
    return cursor.fetchall()


@connection_handler
def get_latest_completion_date_from_social_situation_by_username(cursor, username) -> list[dict]:
    query = """
        SELECT rh.date
        FROM social_situation_result ssr
        JOIN result_header rh on ssr.result_id = rh.id
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
def save_data(cursor:'Cursor', result: list, user_id: int) -> None:
    result_header_id = data_handler_util.add_test_to_result_header(cursor, user_id)
    query = """
    INSERT INTO social_situation_result(answer, question_id, result_id)
    VALUES 
    """
    query += ','.join('(%s, %s, %s)' for _ in result) + ';'
    var = []
    for res in result:
        var.extend([res[1], res[0], result_header_id])  # (answer, question_id, result_id)
    cursor.execute(query, var)


@connection_handler
def patch_media_title_by_id(cursor:'Cursor', media_id: int, title: str) -> None:
    query = """
    UPDATE social_situation_media
    SET title = %s
    WHERE id = %s
    """
    var = (title, media_id)
    cursor.execute(query, var)


@connection_handler
def patch_question_by_id(cursor:'Cursor', question_id: int, question: str) -> None:
    query = """
    UPDATE social_situation_question
    SET question = %s
    WHERE id = %s
    """
    var = (question, question_id)
    cursor.execute(query, var)


@connection_handler
def patch_media_by_id(cursor:'Cursor', media_id: int, media: dict) -> None:
    query = """
    SELECT id
    FROM social_situation_type
    WHERE type = %s
    """
    var = (media["type"],)
    cursor.execute(query, var)
    type_id = cursor.fetchone()["id"]

    query = """
    UPDATE social_situation_media
    SET url = %s, type_id = %s
    WHERE id = %s
    """
    var = (media["url"], type_id, media_id)
    cursor.execute(query, var)

# endregion
