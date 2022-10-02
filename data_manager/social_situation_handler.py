from connection import connection_handler

# region --------------------------------------READ-----------------------------------------
@connection_handler
def get_url_and_questions(cursor) -> list[dict]:
    query = """
    SELECT type, url, array_agg(question) AS questions, social_situation_question.id AS question_id
    FROM (social_situation_type RIGHT JOIN social_situation_media ssm ON social_situation_type.id = ssm.type_id)
        RIGHT JOIN social_situation_question ON social_situation_question.media_id = ssm.id
    GROUP BY url, type, social_situation_question.id;
    """
    cursor.execute(query)
    return cursor.fetchall()

# endregion
# region ---------------------------------------WRITE----------------------------------------

# endregion
