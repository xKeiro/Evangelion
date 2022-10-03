from connection import connection_handler

@connection_handler
def start(cursor, sql):
    res = ' '.join(str(l) for l in sql)
    cursor.execute(res)