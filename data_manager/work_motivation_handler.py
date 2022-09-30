from connection import connection_handler
# region --------------------------------------READ-----------------------------------------

@connection_handler
def get_questions(cursor):
    query = """
    SELECT id, title
    FROM work_motivation_question
    """
    cursor.execute(query)
    return cursor.fetchall()

# endregion
# region ---------------------------------------WRITE----------------------------------------

# endregion
