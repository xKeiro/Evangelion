from connection import connection_handler
from data_manager import data_handler_util


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
def get_situations(cursor):
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


# endregion
# region ---------------------------------------WRITE----------------------------------------
@connection_handler
def save_data(cursor, result, user_id):
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
def patch_media_title_by_id(cursor, media_id: int, title: str):
    query = """
    UPDATE social_situation_media
    SET title = %s
    WHERE id = %s
    """
    var = (title, media_id)
    cursor.execute(query, var)


@connection_handler
def patch_question_by_id(cursor, question_id: int, question: str):
    query = """
    UPDATE social_situation_question
    SET question = %s
    WHERE id = %s
    """
    var = (question, question_id)
    cursor.execute(query, var)


@connection_handler
def patch_media_by_id(cursor, media_id: int, media: dict):
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
