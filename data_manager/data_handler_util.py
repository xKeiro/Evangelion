from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from psycopg import Cursor


def add_test_to_result_header(cursor: 'Cursor', user_id: int) -> int:
    query = """
    INSERT INTO result_header(user_id)
    VALUES (%s)
    RETURNING id;
    """
    var = (user_id,)
    cursor.execute(query, var)
    result_header_id = cursor.fetchone()["id"]
    return result_header_id
