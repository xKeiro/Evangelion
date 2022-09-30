import bcrypt
from flask import session
from flask import render_template
from functools import wraps

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
            return(func(*args, **kwargs))
        except (KeyError):
            return render_template("login_required.jinja2")

    return decorated_function
