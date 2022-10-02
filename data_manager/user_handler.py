from connection import connection_handler
from psycopg import sql


# region --------------------------------------READ-----------------------------------------


@connection_handler
def get_user_fields_by_username(cursor, username: str, field_names: list) -> dict:
    query = "SELECT "
    for field_name in field_names:
        query += f"{field_name},"
    query = query[:-1] + """ FROM users
    WHERE username=%s
    """
    val = (username, )
    cursor.execute(query, val)
    return cursor.fetchone()


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
