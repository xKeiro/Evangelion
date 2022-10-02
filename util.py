import datetime
import gzip
import json
from functools import wraps

import bcrypt
from data_manager import work_motivation_handler, user_handler, common_queries
from flask import make_response
from flask import render_template
from flask import request
from flask import session
from fpdf import FPDF
from datetime import date


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

# region ---------------------------------------PDF----------------------------------------


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
    current_date = str(date.today()).replace("-", "_")

    PDF = set_footer_for_pdf()

    # PDF A4 width = 210, height = 297
    # -----------------------------PDF formatting-------------------------------------
    pdf = PDF()
    pdf.add_page()
    pdf.set_font("Arial", size=16)
    pdf.set_title("Applicants Test Results")
    pdf.set_left_margin(10)
    pdf.set_right_margin(10)
    data_row_height = 8
    title_height = 15
    output_name = f"applicants_test_results_{current_date}.pdf"

    # -------------------------------PDF CONTENT---------------------------------------
    applicants_results = common_queries.get_all_applicant_results()
    print(applicants_results)

    pdf.cell(w=0, h=title_height, txt="Applicants Test Results", ln=1, align="C")

    # HEADERS--------------------------------
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

    # RESULTS--------------------------------
    for applicant in applicants_results:
        for i, test_result in enumerate(applicant.values()):
            pdf.cell(w=pdf_col_width_values[i],
                     h=data_row_height,
                     txt=test_result,
                     ln=0 if i != len(pdf_col_width_values) - 1 else 1,
                     align="C")

    return pdf.output(output_name)


def get_applicant_tests_results_into_pdf(username, full_name_for_filename):
    current_date = str(date.today()).replace("-", "_")
    test_completion_date = current_date.replace("_", " ").split()
    test_completion_date = ". ".join(test_completion_date) + "."
    full_name_normal = full_name_for_filename.replace("_", " ").rstrip()

    PDF = set_footer_for_pdf()

    # PDF A4 width = 210, height = 297
    # -----------------------------PDF formatting-------------------------------------
    pdf = PDF()
    pdf.add_page()
    pdf.set_font("Arial", "B", size=16)
    pdf.set_title(f"{full_name_normal} Eredmények")
    pdf.set_left_margin(10)
    pdf.set_right_margin(10)
    data_row_height = 8
    title_height = 15
    output_name = f"{full_name_for_filename}{current_date}.pdf"

    # -------------------------------PDF CONTENT---------------------------------------

    pdf.cell(w=130, h=title_height, txt=f"{full_name_normal} Eredmények", ln=0, align="R")

    pdf.set_font("Arial", "I", size=8)

    pdf.cell(w=60, h=title_height, txt=f"Kitöltötte: {test_completion_date}", ln=1, align="R")

    # WORK MOTIVATION SECTION--------------------------------
    pdf.set_font("Arial", "BI", size=8)

    pdf.cell(w=0, h=data_row_height, txt="Munka Motiváció Teszt Pontok", ln=1)

    pdf.set_font("Arial", size=8)

    categories_max_points = work_motivation_handler.get_categories_max_points()
    work_motivation_results = work_motivation_handler.get_results_for_applicant(username)

    for i, category in enumerate(work_motivation_results):
        pdf.cell(w=30,
                 h=data_row_height,
                 txt=f'{category["title"]}',
                 ln=0,
                 border=1)
        pdf.cell(w=10,
                 h=data_row_height,
                 txt=f'{category["cat_score"]} / {categories_max_points[i]["max_point"]}',
                 ln=1,
                 border=1,
                 align="C")

    return pdf.output(output_name)


def set_footer_for_pdf():
    class PDF(FPDF):
        def footer(self):
            # Go to 1.5 cm from bottom
            self.set_y(-15)
            # Select Arial italic 8
            self.set_font('Arial', 'I', 8)
            # Print centered page number
            self.cell(0, 10, str(self.page_no()), 0, 0, 'C')
    return PDF

# endregion
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
