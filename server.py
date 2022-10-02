from flask import Flask  # type: ignore
from flask import make_response
from flask import redirect
from flask import render_template
from flask import request
from flask import session
from flask import url_for
import mimetypes

import util
from data_manager import english_test_handler
from data_manager import language_handler
from data_manager import user_handler
from data_manager import work_motivation_test_handler
from data_manager import social_situation_handler

mimetypes.add_type('application/javascript', '.js')
mimetypes.add_type('text/css', '.css')

app = Flask(__name__)
app.secret_key = ("b'o\xa7\xd9\xddj\xb0n\x92qt\xcc\x13\x113\x1ci'")


@app.context_processor
def inject_dict_for_all_templates():
    text = language_handler.get_texts_in_language(request.cookies.get("language", "hu"))
    return dict(text=text)


@app.route('/')
def index():
    resp = make_response(render_template("index.jinja2"))
    resp.set_cookie('language', 'en')
    return resp


# region -------------------------------AUTHENTICATION-----------------------------------------
@app.route('/register', methods=["GET", "POST"])
def register():
    if request.method == "POST":
        expected_fields = ["username", "password", "email", "last_name", "first_name", "birthday"]
        fields = request.form.to_dict();
        fields = {key: fields[key] for key in fields if key in expected_fields}
        fields["password"] = util.hash_password(fields["password"])
        try:
            user_handler.add_new_user(fields)
        except:
            return render_template("authentication/register.jinja2", matching_username=True)
        user_fields = user_handler.get_user_fields_by_username(fields["username"], ["id", "is_admin"])
        session["username"] = fields["username"]
        session["is_admin"] = user_fields["is_admin"]
        session["user_id"] = user_fields["id"]
        return redirect(url_for('index'))
    return render_template("authentication/register.jinja2", matching_username=False)


@app.route('/login', methods=["GET", "POST"])
def login():
    login_attempt_failed = False
    if request.method == "POST":
        expected_fields = ["username", "password"]
        fields = request.form.to_dict();
        fields = {key: fields[key] for key in fields if key in expected_fields}
        try:
            user_fields = user_handler.get_user_fields_by_username(fields["username"], ["id", "password", "is_admin"])
            hashed_password = user_fields["password"]
            is_admin = user_fields["is_admin"]
            user_id = user_fields["id"]
            is_valid_login = util.check_password(fields["password"], hashed_password)
            if is_valid_login:
                session["username"] = fields["username"]
                session["is_admin"] = is_admin
                session["user_id"] = user_id
                return redirect(url_for("index"))
        except:
            login_attempt_failed = True
    return render_template("authentication/login.jinja2", login_attempt_failed=login_attempt_failed)


@app.route('/logout')
@util.login_required
def logout():
    session.pop("username")
    session.pop("is_admin")
    session.pop("user_id")
    return redirect(request.referrer)


# endregion
@app.route('/tests')
@util.login_required
def tests():
    return render_template('tests.jinja2')

@app.route('/test/work-motivation')
@util.login_required
def work_motivation():
    questions = work_motivation_test_handler.get_questions()
    return render_template('tests/work_motivation.jinja2', questions=questions)


@app.route('/test/english_language/<difficulty_id>')
@util.login_required
def english_language(difficulty_id):
    test = english_test_handler.get_random_english_test_by_difficulty_id(difficulty_id)
    return render_template('tests/english_language.jinja2', test=test)

@app.route('/test/social_situation')
@util.login_required
def social_situation():

    return render_template('tests/social_situations.jinja2')


# region --------------------------------API------------------------------------------
@app.route('/api/text')
@util.json_response
def api_get_text():
    text = language_handler.get_texts_in_language(request.cookies.get("language", "hu"))
    return text


@app.route('/api/work-motivation', methods=["POST"])
@util.login_required
@util.json_response
def api_work_motivation_submit():
    answers = request.json
    work_motivation_test_handler.submit_answer(answers, session["user_id"])
    return {"status": "success"}


@app.route('/api/work-motivation/question/<question_id>', methods=["PATCH"])
@util.login_required
@util.json_response
def api_patch_work_motivation_question(question_id):
    if session["is_admin"]:
        title = request.json["title"]
        work_motivation_test_handler.patch_title_by_id(question_id, title)
        return {"status": "success"}

# endregion
