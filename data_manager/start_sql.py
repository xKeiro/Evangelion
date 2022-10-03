from connection import connection_handler

@connection_handler
def start(cursor, sql):
    sql = ' '.join(str(l) for l in sql)
    cursor.execute(sql)