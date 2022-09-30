import functools
import os

import psycopg
from psycopg.rows import dict_row



def get_connection_string():
    # setup connection string
    # to do this, please define these environment variables first
    user_name = os.environ.get('MY_PSQL_USER')
    password = os.environ.get('MY_PSQL_PASSWORD')
    host = os.environ.get('MY_PSQL_HOST')
    database_name = os.environ.get('MY_PSQL_DBNAME')

    env_variables_defined = user_name and password and host and database_name

    if env_variables_defined:
        # this string describes all info for psycopg to connect to the database
        return 'postgresql://{user_name}:{password}@{host}/{database_name}'.format(
            user_name=user_name,
            password=password,
            host=host,
            database_name=database_name
        )
    else:
        raise KeyError('Some necessary environment variable(s) are not defined')


def open_database():
    try:
        connection_string = get_connection_string()
        connection = psycopg.connect(connection_string)
        connection.autocommit = True
    except psycopg.DatabaseError as exception:
        print('Database connection problem')
        raise exception
    return connection


def connection_handler(function):
    @functools.wraps(function)
    def wrapper(*args, **kwargs):
        connection = open_database()
        # we set the row_factory parameter so the cursor returns with dictionaries
        dict_cur = connection.cursor(row_factory=dict_row)
        ret_value = function(dict_cur, *args, **kwargs)
        dict_cur.close()
        connection.close()
        return ret_value

    return wrapper
