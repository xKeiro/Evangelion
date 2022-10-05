from typing import TYPE_CHECKING

from connection import connection_handler

if TYPE_CHECKING:
    pass


@connection_handler
def start(cursor: 'Cursor', sql:list):
    res = ' '.join(str(l) for l in sql)
    cursor.execute(res)
