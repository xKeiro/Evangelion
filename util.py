import gzip
import json
import bcrypt
from functools import wraps
from flask import render_template
from flask import session
from flask import make_response


def hash_password(password):
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')


def check_password(password, hashed_password):
    return bcrypt.checkpw(password.encode('utf-8'), hashed_password.encode('utf-8'))


def login_required(func):
    """
    Checks if user is loggen in, if not shows the "login_required.jinja2" template
    :param func:
    :return:
    """

    @wraps(func)
    def decorated_function(*args, **kwargs):
        try:
            session["username"]
            return (func(*args, **kwargs))
        except (KeyError):
            return render_template("authentication/login_required.jinja2")

    return decorated_function

def json_response(func):
    """
    Converts the returned dictionary into a JSON response
    :param func:
    :return:
    """

    @wraps(func)
    def decorated_function(*args, **kwargs):
        content = gzip.compress(json.dumps(func(*args, **kwargs)).encode('utf8'))
        response = make_response(content)
        response.headers['Content-length'] = len(content)
        response.headers['Content-Encoding'] = 'gzip'
        return response

    return decorated_function
