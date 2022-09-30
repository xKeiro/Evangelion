from connection import connection_handler


# region --------------------------------------READ-----------------------------------------


@connection_handler
def get_user_password_by_username(cursor, username):
    query = """
    SELECT password
    FROM users
    WHERE username=%s
    """
    val = (username,)
    cursor.execute(query, val)
    return cursor.fetchone()["password"]


# endregion
# region ---------------------------------------WRITE----------------------------------------


@connection_handler
def add_new_user(cursor, fields):
    query = """
    INSERT INTO users(""" + ", ".join(fields) + ") VALUES ("
    for _ in fields:
        query += "%s, "
    query = query[:-2] + ")"
    val = [field for field in fields.values()]
    cursor.execute(query, val)

# endregion
