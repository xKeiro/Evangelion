from connection import connection_handler
from psycopg import sql


# region --------------------------------------READ-----------------------------------------

@connection_handler
def get_texts_in_language(cursor, language):
    query = sql.SQL("""
    SELECT hu as default_language, {}
    FROM language
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
