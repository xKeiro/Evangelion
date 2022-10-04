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
@connection_handler
def save_data(cursor, answer, question_id, user_id):
    query = """
    INSERT INTO social_situation_result(answer, question_id, user_id)
    VALUES (%s, %s, %s);
    """
    var = (answer, question_id, user_id)
    cursor.execute(query, var)

# endregion
