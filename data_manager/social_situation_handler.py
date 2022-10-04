from connection import connection_handler

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
    query="""
    SELECT ARRAY[sst.type, ssm.url, ssm.title] as media, array_agg(ARRAY[ssq.id::varchar, ssq.question]) as questions
    FROM social_situation_media ssm
    JOIN social_situation_type sst ON ssm.type_id = sst.id
    JOIN social_situation_question ssq ON ssm.id = ssq.media_id
    GROUP BY ssm.id, sst.type, ssm.url, ssm.title
    ORDER BY ssm.id
    """
    cursor.execute(query)
    situations = cursor.fetchall()
    for index, situation in enumerate(situations):
        media = {"type": situation["media"][0], "url": situation["media"][1], "title": situation["media"][2]}
        questions = [{"id": int(question[0]), "question": question[1]} for question in
                     situation["questions"]]
        situations[index]["media"] = media
        situations[index]["questions"] = questions
    return situations

# endregion
# region ---------------------------------------WRITE----------------------------------------
@connection_handler
def save_data(cursor, result, user_id):
    query = """
    INSERT INTO social_situation_result(answer, question_id, user_id)
    VALUES 
    """
    query += ','.join('(%s, %s, %s)' for l in result) + ';'
    var = []
    for res in result:
        var.extend([res[1], res[0], user_id]) # (answer, question_id, user_id)
    cursor.execute(query, var)

# endregion
