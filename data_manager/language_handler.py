from typing import TYPE_CHECKING

from psycopg import sql
from connection import connection_handler

if TYPE_CHECKING:
    from psycopg import Cursor


# region --------------------------------------READ-----------------------------------------

@connection_handler
def get_texts_in_language(cursor: 'Cursor', language: str) -> dict:
    query = sql.SQL("""
    SELECT hu AS default_language, {}
    FROM LANGUAGE
    """).format(sql.Identifier(language))
    cursor.execute(query)
    text = cursor.fetchall()
    text_in_selected_language = dict()
    for line in text:
        text_in_selected_language[line["default_language"]] = line[language]
    return text_in_selected_language

# endregion
# region ---------------------------------------WRITE----------------------------------------

# endregion
