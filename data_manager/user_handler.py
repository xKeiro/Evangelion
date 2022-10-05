from typing import TYPE_CHECKING
from connection import connection_handler

if TYPE_CHECKING:
    from psycopg import Cursor


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
def get_email_and_full_name_by_username(cursor: 'Cursor', username: str) -> dict:
    query = """
    SELECT CONCAT(last_name, ' ', first_name) AS full_name, email
    FROM users
    WHERE username LIKE %s
    """
    val = (username, )
    cursor.execute(query, val)
    return cursor.fetchone()


@connection_handler
def get_username_and_full_name_by_email(cursor:'Cursor', email: str) -> dict:
    query = """
    SELECT username, CONCAT(last_name, ' ', first_name) AS full_name
    FROM users
    WHERE email LIKE %s
    """
    val = (email, )
    cursor.execute(query, val)
    return cursor.fetchone()

@connection_handler
def get_users_by_their_latest_tests(cursor:'Cursor') -> list[dict]:
    query = """
    SELECT username, email, first_name, last_name, birthday, date
    FROM users
    JOIN (SELECT user_id, date
    FROM result_header
    GROUP BY user_id, date
    HAVING date = MAX(date)) max_users ON users.id = max_users.user_id
    ORDER BY date ASC
    """
    cursor.execute(query)
    return cursor.fetchall()


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
