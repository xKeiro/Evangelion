import gzip
import json
from functools import wraps

import bcrypt
from flask import make_response
from flask import render_template
from flask import request
from flask import session
from fpdf import FPDF


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


def get_applicants_results_into_pdf():
    applicants = [
        {
            "name": "Flash Elek",
            "chair_lamp": "98%",
            "toulouse": "100%",
            "bourdon": "94%",
            "english": "82%",
            "social": "69%",
            "work_motivation": "10000"
        },
        {
            "name": "Sprint Elek",
            "chair_lamp": "10%",
            "toulouse": "77%",
            "bourdon": "81%",
            "english": "35%",
            "social": "12%",
            "work_motivation": "1009"
        },
        {
            "name": "Liácska",
            "chair_lamp": "100%",
            "toulouse": "100%",
            "bourdon": "100%",
            "english": "100%",
            "social": "100%",
            "work_motivation": "420"
        },
        {
            "name": "Kevin",
            "chair_lamp": "100%",
            "toulouse": "100%",
            "bourdon": "100%",
            "english": "100%",
            "social": "100%",
            "work_motivation": "1337"
        },
        {
            "name": "Miki",
            "chair_lamp": "100%",
            "toulouse": "100%",
            "bourdon": "100%",
            "english": "100%",
            "social": "100%",
            "work_motivation": "9696"
        },
        {
            "name": "Roli",
            "chair_lamp": "100%",
            "toulouse": "100%",
            "bourdon": "100%",
            "english": "100%",
            "social": "100%",
            "work_motivation": "9955"
        },
        {
            "name": "Abdahibunia Skalamatorbus",
            "chair_lamp": "10%",
            "toulouse": "10%",
            "bourdon": "10%",
            "english": "10%",
            "social": "10%",
            "work_motivation": "100"
        }
    ]
    result_headers = [
        "Name",
        "Chair-Lamp",
        "Toulouse-Piéron Cancelation",
        "Bourdon",
        "English Language",
        "Social Situations",
        "Work Motivation"
    ]
    pdf_col_width_values = [35, 20, 40, 15, 28, 27, 25]  # SUM = 190
    data_row_height = 8
    title_height = 15
    # PDF A4 width = 210, height = 297

    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=16)
    pdf.set_title("Applicants Test Results")
    pdf.set_left_margin(10)
    pdf.set_right_margin(10)

    pdf.cell(w=0, h=title_height, txt="Applicants Test Results", ln=1, align="C")

    pdf.set_font("Arial", size=8)

    for i in range(len(result_headers)):
        if i == 0:
            line_start_x = pdf.get_x()
            line_start_y = pdf.get_y() + data_row_height
            line_end_x = sum(pdf_col_width_values) + 10

        pdf.cell(w=pdf_col_width_values[i],
                 h=data_row_height,
                 txt=result_headers[i],
                 ln=0 if i != len(result_headers) - 1 else 1,
                 align="C")

    pdf.line(line_start_x, line_start_y, line_end_x, line_start_y)

    for applicant in applicants:
        for i, test_result in enumerate(applicant.values()):
            pdf.cell(w=pdf_col_width_values[i],
                     h=data_row_height,
                     txt=test_result,
                     ln=0 if i != len(pdf_col_width_values) - 1 else 1,
                     align="C")

    return pdf.output("applicants_test_results.pdf")



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
