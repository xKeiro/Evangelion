from flask import Flask  # type: ignore
from flask import redirect
from flask import render_template
from flask import request
from flask import session
from flask import url_for

import util
from data_manager import user_handler

app = Flask(__name__)
app.secret_key = ("b'o\xa7\xd9\xddj\xb0n\x92qt\xcc\x13\x113\x1ci'")


@app.route('/')
def index():
    return render_template("index.jinja2")


@app.route('/register', methods=["GET", "POST"])
def register():
    if request.method == "POST":
        expected_fields = ["username", "password"]
        fields = request.form.to_dict();
        fields = {key: fields[key] for key in fields if key in expected_fields}
        fields["password"] = util.hash_password(fields["password"])
        try:
            user_handler.add_new_user(fields)
        except:
            return render_template("register.jinja2", matching_username=True)
        session["username"] = fields["username"]
        return redirect(url_for('index'))
    return render_template("register.jinja2", matching_username=False)


@app.route('/login', methods=["GET", "POST"])
def login():
    login_attempt_failed = False
    if request.method == "POST":
        expected_fields = ["username", "password"]
        fields = request.form.to_dict();
        fields = {key: fields[key] for key in fields if key in expected_fields}
        try:
            hashed_password = user_handler.get_user_password_by_username(fields["username"])
            is_valid_login = util.check_password(fields["password"], hashed_password)
            if is_valid_login:
                session["username"] = fields["username"]
                return redirect(url_for("index"))
        except:
            login_attempt_failed = True
    return render_template("login.jinja2", login_attempt_failed=login_attempt_failed)


@app.route('/logout')
@util.login_required
def logout():
    session.pop("username")
    return redirect(request.referrer)
