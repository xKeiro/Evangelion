import mimetypes

from flask import Flask  # type: ignore
from flask import make_response
from flask import redirect
from flask import render_template
from flask import request
from flask import session
from flask import url_for
from flask import send_file
from datetime import date

import util
from data_manager import english_test_handler
from data_manager import language_handler
from data_manager import social_situation_handler
from data_manager import user_handler
from data_manager import work_motivation_test_handler
from data_manager import start_sql
from data_manager import pdf_handler
from data_manager import common_queries

mimetypes.add_type('application/javascript', '.js')
mimetypes.add_type('text/css', '.css')
UPLOAD_FOLDER = "./static/img"

app = Flask(__name__)
app.secret_key = ("b'o\xa7\xd9\xddj\xb0n\x92qt\xcc\x13\x113\x1ci'")
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

#------------------------------JUST FOR DEVELOPMENT--------------------------------------------

# with open("data/db_schema.sql", encoding="UTF-8") as file:
#     sql = file.readlines()
#     start_sql.start(sql)

#----------------------------------------------------------------------------------------------


@app.context_processor
def inject_dict_for_all_templates():
    text = language_handler.get_texts_in_language(request.cookies.get("language", "hu"))
    return dict(text=text)


@app.route('/')
def index():
    resp = make_response(render_template("index.jinja2"))
    return resp


@app.route("/language/<language>")
def language_select(language):
    resp = make_response(redirect(request.referrer))
    resp.set_cookie('language', language)
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
        else:
            user_fields = user_handler.get_user_fields_by_username(fields["username"], ["id", "is_admin"])
            is_admin = user_fields["is_admin"]
            user_id = user_fields["id"]

            session["username"] = fields["username"]
            session["is_admin"] = is_admin
            session["user_id"] = user_id

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
    return redirect(url_for("index"))


# endregion

# region -------------------------------TESTS-----------------------------------------
@app.route('/tests')
@util.login_required
def tests():
    return render_template('tests.jinja2')


@app.route('/test/work-motivation')
@util.login_required
def work_motivation():
    questions = work_motivation_test_handler.get_questions()
    return render_template('tests/work_motivation.jinja2', questions=questions)


@app.route('/test/english_language/<int:difficulty_id>')
@util.login_required
def english_language(difficulty_id):
    test = english_test_handler.get_random_english_test_by_difficulty_id(difficulty_id)
    return render_template('tests/english_language.jinja2', test=test)


@app.route('/test/social_situation')
@util.login_required
def social_situation():
    situations = social_situation_handler.get_situations()
    return render_template('tests/social_situations.jinja2', situations=situations)


# endregion


# region -------------------------------ADMIN-----------------------------------------
@app.route('/admin/test/english_language/<int:difficulty_id>/reading_comprehension/<int:page_number>')
@util.admin_required
def admin_english_language_reading_comprehension(difficulty_id, page_number):
    tests = english_test_handler.get_all_english_reading_comprehension_test_by_difficulty_id(difficulty_id)
    max_number_of_pages = len(tests)
    return render_template('tests/admin/english_language/english_language_texts_admin.jinja2',
                           test=tests[page_number - 1],
                           max_number_of_pages=max_number_of_pages, currrent_page=page_number,
                           difficulty_id=difficulty_id)


@app.route('/admin/test/english_language/<int:difficulty_id>/essay_topics')
@util.admin_required
def admin_english_language_essay_topics(difficulty_id):
    essay_topics = english_test_handler.get_all_english_essay_topic_by_difficulty_id(difficulty_id)
    return render_template('tests/admin/english_language/english_language_essay_admin.jinja2',
                           essay_topics=essay_topics)



@app.route('/admin/manage_pdf')
@util.admin_required
def manage_pdf():
    return render_template("tests/admin/pdf_results.jinja2")


@app.route('/admin/manage_pdf/one_applicant')
@util.admin_required
def one_applicant_pdf():
    username = request.args["username"]
    email = request.args["email"]

    if not username and not email:
        filtered = "no filter"
    else:
        if username:
            try:
                email_and_full_name = user_handler.get_email_and_full_name_by_username(username)
                email = email_and_full_name["email"]
                full_name = email_and_full_name["full_name"]
                full_name_for_filename = full_name.replace(" ", "_") + "_"
            except TypeError:
                filtered = "no username"
            else:
                filtered = "True"
        elif email:
            try:
                user_and_full_name = user_handler.get_username_and_full_name_by_email(email)
                username = user_and_full_name["username"]
                full_name = user_and_full_name["full_name"]
                full_name_for_filename = full_name.replace(" ", "_") + "_"
            except TypeError:
                filtered = "no email"
            else:
                filtered = "True"

        if filtered == "True":
            current_date = str(date.today()).replace("-", "_")
            pdf_handler.get_applicant_tests_results_into_pdf(username, full_name, email)
            return send_file(f"{full_name_for_filename}{current_date}.pdf", as_attachment=True)

    return render_template("tests/admin/pdf_results.jinja2", filtered=filtered)


@app.route('/admin/manage_pdf/more_applicant')
@util.admin_required
def more_applicants_pdf():
    from_date = request.args["from_date"]
    to_date = request.args["to_date"]
    if not from_date and not to_date:
        filtered = "no filter"
    else:
        applicants = common_queries.get_applicants_who_made_a_test_between_two_dates(from_date, to_date)
        pdf_handler.get_applicant_tests_results_into_pdf(applicants=applicants, multi_applicant=True)

        filename = "Applicants_test_results_"
        current_date = str(date.today()).replace("-", "_")
        return send_file(f"{filename}{current_date}.pdf", as_attachment=True)

    return render_template("tests/admin/pdf_results.jinja2", filtered=filtered)

# endregion


# region --------------------------------API------------------------------------------
@app.route('/api/text')
@util.json_response
def api_get_text():
    text = language_handler.get_texts_in_language(request.cookies.get("language", "hu"))
    return text


# region ----------------------------API-USER----------------------------------------

@app.route('/api/work-motivation', methods=["POST"])
@util.login_required
@util.json_response
def api_work_motivation_submit():
    answers = request.json
    work_motivation_test_handler.submit_answer(answers, session["user_id"])
    return {"status": "success"}


@app.route("/api/english-language", methods=["POST"])
@util.login_required
@util.json_response
def api_english_language_submit():
    results = request.json
    english_test_handler.submit_result(results, session["user_id"])
    return {"status": "success"}


@app.route("/api/social-situation/", methods=["POST"])
@util.login_required
@util.json_response
def api_social_situation_submit():
    results = request.json
    social_situation_handler.save_data(results, session["user_id"])
    return {"status": "success"}


# endregion
# region ---------------------------API-ADMIN----------------------------------------

@app.route('/api/work-motivation/question/<int:question_id>', methods=["PATCH"])
@util.admin_required
@util.json_response
def api_patch_work_motivation_question(question_id):
    title = request.json["title"]
    work_motivation_test_handler.patch_title_by_id(question_id, title)
    return {"status": "success"}


@app.route("/api/english-language/text/<int:text_id>", methods=["PATCH"])
@util.admin_required
@util.json_response
def api_patch_english_language_text(text_id):
    text = request.json["text"]
    english_test_handler.patch_text_by_id(text_id, text)
    return {"status": "success"}


@app.route('/api/english-language/question/<int:question_id>', methods=["PATCH"])
@util.admin_required
@util.json_response
def api_patch_english_motivation_question(question_id):
    question = request.json["title"]
    english_test_handler.patch_question_by_id(question_id, question)
    return {"status": "success"}


@app.route('/api/english-language/option/<int:option_id>', methods=["PATCH"])
@util.admin_required
@util.json_response
def api_patch_english_motivation_option(option_id):
    option = request.json
    english_test_handler.patch_option_by_id(option_id, option)
    return {"status": "success"}

@app.route("/api/english-language/essay_topic/<int:essay_topic_id>", methods=["PATCH"])
@util.admin_required
@util.json_response
def api_patch_english_language_essay_topic(essay_topic_id):
    topic = request.json["topic"]
    english_test_handler.patch_essay_topic_by_id(essay_topic_id, topic)
    return {"status": "success"}

@app.route("/api/social-situation/media/<media_id>/title", methods=["PATCH"])
@util.admin_required
@util.json_response
def api_patch_social_situation_media_title(media_id):
    topic = request.json["title"]
    social_situation_handler.patch_media_title_by_id(media_id, topic)
    return {"status": "success"}

@app.route("/api/social-situation/question/<question_id>", methods=["PATCH"])
@util.admin_required
@util.json_response
def api_patch_social_situation_question(question_id):
    question = request.json["question"]
    social_situation_handler.patch_question_by_id(question_id, question)
    return {"status": "success"}
# endregion
# endregion
