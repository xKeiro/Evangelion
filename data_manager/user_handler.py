from typing import TYPE_CHECKING
from connection import connection_handler

if TYPE_CHECKING:
    pass


# region --------------------------------------READ-----------------------------------------


@connection_handler
def get_user_fields_by_username(cursor: 'Cursor', username: str, field_names: list) -> dict:
    query = "SELECT "
    for field_name in field_names:
        query += f"{field_name},"
    query = query[:-1] + """ FROM users
    WHERE username=%s
    """
    val = (username,)
    cursor.execute(query, val)
    return cursor.fetchone()


@connection_handler
def get_email_and_full_name_by_username(cursor, username) -> dict:
    query = """
    SELECT CONCAT(last_name, ' ', first_name) AS full_name, email
    FROM users
    WHERE username LIKE %s
    """
    val = (username, )
    cursor.execute(query, val)
    return cursor.fetchone()


@connection_handler
def get_username_and_full_name_by_email(cursor, email) -> dict:
    query = """
    SELECT username, CONCAT(last_name, ' ', first_name) AS full_name
    FROM users
    WHERE email LIKE %s
    """
    val = (email, )
    cursor.execute(query, val)
    return cursor.fetchone()

# endregion
# region ---------------------------------------WRITE----------------------------------------


@connection_handler
def add_new_user(cursor: 'Cursor', fields: dict) -> None:
    query = """
    INSERT INTO users(""" + ", ".join(fields) + ") VALUES ("
    for _ in fields:
        query += "%s, "
    query = query[:-2] + ")"
    val = [field for field in fields.values()]
    cursor.execute(query, val)

# endregion
