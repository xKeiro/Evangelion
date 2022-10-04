from connection import connection_handler


@connection_handler
def get_all_applicant_results(cursor) -> list[dict]:
    query = """
    SELECT CONCAT(u.last_name, ' ', u.first_name) AS full_name, CONCAT(SUM(score), ' / ', COUNT(*) * 5) AS work_motivation_score
    FROM work_motivation_result wmr
    JOIN result_header rh on wmr.result_header_id = rh.id
    JOIN users u on rh.user_id = u.id
    GROUP BY full_name
    ORDER BY full_name
    """
    cursor.execute(query)
    return cursor.fetchall()
