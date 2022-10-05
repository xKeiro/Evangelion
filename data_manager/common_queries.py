import datetime

from connection import connection_handler


@connection_handler
def get_applicants_who_made_a_test_between_two_dates(cursor, date_from="", date_to="") -> list[dict]:
    if not date_from:
        date_from = str((datetime.datetime.strptime(date_to, "%Y-%m-%d") - datetime.timedelta(days=14)).date())
    if not date_to:
        date_to = str(datetime.date.today())

    query = """
    SELECT DISTINCT u.username, CONCAT(u.last_name, ' ', u.first_name) AS full_name, u.email
    FROM result_header rh
    JOIN users u on u.id = rh.user_id
    WHERE rh.date BETWEEN %s AND %s
    """
    cursor.execute(query, (date_from, date_to))
    return cursor.fetchall()
