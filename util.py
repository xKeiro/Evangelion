import gzip
import json
import os
from functools import wraps

import bcrypt
from flask import make_response
from flask import render_template
from flask import request
from flask import session
from werkzeug.utils import secure_filename

ALLOWED_EXTENSIONS = ('png', 'jpg', 'jpeg', 'webp')


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def save_image(app):
    file = request.files['image']
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))


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
        except (KeyError):
            return render_template("authentication/login_required.jinja2")
        return (func(*args, **kwargs))

    return decorated_function


def admin_required(func):
    """
    Checks if user is admin, if not shows the "admin_required.jinja2" template
    :param func:
    :return:
    """

    @wraps(func)
    def decorated_function(*args, **kwargs):
        try:
            is_admin = session["is_admin"]
        except KeyError:
            return render_template("authentication/admin_required.jinja2")
        if is_admin:
            return (func(*args, **kwargs))
        else:
            return render_template("authentication/admin_required.jinja2")

    return decorated_function


# region ---------------------------------------LANGUAGE----------------------------------------
# def get_language(func):
#     """
#     Sets language to hungarian if there's no language in cookies
#     :param func:
#     :return:
#     """
#
#     @wraps(func)
#     def decorated_function(*args, **kwargs):
#         language = request.cookies.get("language")
#         if language:
#             return (func(language, *args, **kwargs))
#         else:
#             return (func("hu", *args, **kwargs))
#
#     return decorated_function


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
