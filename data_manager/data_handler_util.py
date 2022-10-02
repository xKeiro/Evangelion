def add_test_to_result_header(cursor, user_id):
    query = """
    INSERT INTO result_header(user_id)
    VALUES (%s)
    RETURNING id;
    """
    var = (user_id,)
    cursor.execute(query, var)
    result_header_id = cursor.fetchone()["id"]
    return result_header_id
