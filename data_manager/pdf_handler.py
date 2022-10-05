from fpdf import FPDF
from datetime import date

from data_manager import work_motivation_test_handler
from data_manager import user_handler
from data_manager import common_queries
from data_manager import english_test_handler
from data_manager import social_situation_handler


def get_applicants_results_into_pdf():
    # "Name",
    # "Chair-Lamp",
    # "Toulouse-Piéron Cancelation",
    # "Bourdon",
    # "English Language",
    # "Social Situations",
    # "Work Motivation"

    pdf_col_width_values = [35, 20, 40, 15, 28, 27, 25]  # SUM = 190
    current_date = str(date.today()).replace("-", "_")

    PDF = set_footer_for_pdf()

    # PDF A4 width = 210, height = 297
    # -----------------------------PDF formatting-------------------------------------
    pdf = PDF()
    pdf = add_fonts(pdf)
    pdf.add_page()
    pdf.set_font("Calibri", size=16)
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
    pdf.set_font("Calibri", size=8)
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


def get_applicant_tests_results_into_pdf(username, full_name, email):
    current_date = str(date.today()).replace("-", "_")
    full_name_for_filename = full_name.replace(" ", "_") + "_"

    PDF = set_footer_for_pdf()
    # PDF A4 width = 210, height = 297
    # -----------------------------PDF formatting-------------------------------------
    pdf = PDF()
    pdf = add_fonts(pdf)
    # FONTS
    # Calibri   - Normal
    # Calibrib  - Bold
    # Calibrii  - Italic
    # Calibril  - Light
    # Calibrili - Light Italic
    # Calibriz  - Bold Italic

    pdf.add_page()
    pdf.image("static/resources/salva_vita_logo.jpg", x=10, y=5, h=20, w=20)
    pdf.set_font("Calibrib", size=16)
    pdf.set_title(f"{full_name} Eredmények")
    pdf.set_left_margin(10)
    pdf.set_right_margin(10)
    data_row_height = 8
    title_height = 8
    output_name = f"{full_name_for_filename}{current_date}.pdf"

    # -------------------------------PDF CONTENT---------------------------------------

    pdf.cell(w=0, h=title_height, txt=f"{full_name} - Eredmények", ln=1, align="C")

    pdf.set_font("Calibriz", size=9)
    pdf.cell(w=0, h=data_row_height - 3, txt=f"{email}", ln=1, align="C")
    pdf.ln()
    pdf.ln()

    # ENGLISH LANGUAGE SECTION--------------------------------
    eng_test_essay_diff_comp_date = english_test_handler.get_english_test_essay_diff_and_completion_date_by_username(username)

    if eng_test_essay_diff_comp_date is not None:
        eng_test_question_results = english_test_handler.get_english_test_questions_results_by_username(username)
        difficulty = "Alapfok" if eng_test_essay_diff_comp_date["difficulty"] == "Elementary" else "Középfok" if eng_test_essay_diff_comp_date["difficulty"] == "Intermediate" else "Felsőfok"
        eng_test_completion_date = change_date_format(eng_test_essay_diff_comp_date["date"])
        essay = eng_test_essay_diff_comp_date["essay"]

        pdf.set_font("Calibriz", size=11)
        pdf.set_text_color(17, 71, 158)
        pdf.cell(w=95, h=data_row_height, txt=f"Angol nyelvtudás - {difficulty}", ln=0)

        pdf.set_font("Calibrii", size=8)
        pdf.set_text_color(0, 0, 0)
        pdf.cell(w=95, h=data_row_height, txt=f"Kitöltötte: {eng_test_completion_date}", ln=1, align="R")

        pdf.set_left_margin(15)
        pdf.set_font("Calibri", size=8)
        correct_answers = 0
        wrong_answers = 0
        for test_part in eng_test_question_results:
            pdf.write(h=data_row_height, txt=test_part["question"].split(".............")[0])

            if test_part["correct"]:
                pdf.set_text_color(58, 173, 35)
                correct_answers += 1
            else:
                pdf.set_text_color(219, 18, 11)
                wrong_answers += 1

            pdf.write(h=data_row_height, txt=test_part["given_answer"])
            pdf.set_text_color(0, 0, 0)
            pdf.write(h=data_row_height, txt=test_part["question"].split(".............")[1])
            pdf.ln()

        pdf.set_font("Arial", "BU", size=8)
        pdf.cell(w=0, h=data_row_height, txt=f"Elért pontszám: {correct_answers} / {correct_answers + wrong_answers}",
                 ln=1)
        pdf.ln()

        pdf.set_font("Calibriz", size=9)
        pdf.cell(w=0, h=data_row_height, txt=f"{eng_test_essay_diff_comp_date['topic']}", ln=1)

        pdf.set_font("Calibri", size=8)
        pdf.multi_cell(w=0, h=data_row_height - 3, txt=f"{essay}")

        pdf.ln()
        pdf.set_font("Arial", "B", size=8)
        pdf.cell(w=0, h=data_row_height, txt="Elért pontszám:__________", ln=1)
        pdf.ln()
    else:
        pdf.set_font("Calibriz", size=10)
        pdf.set_text_color(17, 71, 158)
        pdf.cell(w=95, h=data_row_height, txt=f"Angol nyelvtudás", ln=1)

    # SOCIAL SITUATIONS SECTION--------------------------------
    pdf.set_left_margin(10)
    pdf.set_font("Calibriz", size=11)
    pdf.set_text_color(17, 71, 158)
    pdf.cell(w=95, h=data_row_height, txt="Társasági Szituációk", ln=0)
    pdf.set_text_color(0, 0, 0)

    soc_situations_completion_date = social_situation_handler.get_latest_completion_date_from_social_situation_by_username(username)
    if soc_situations_completion_date is not None:
        soc_situations_completion_date = change_date_format(soc_situations_completion_date["date"])
        situations_and_answers = social_situation_handler.get_situations_for_pdf_by_username(username)

        pdf.set_font("Calibrii", size=8)
        pdf.cell(w=95, h=data_row_height, txt=f"Kitöltötte: {soc_situations_completion_date}", ln=1, align="R")
        pdf.ln()

        previous_title = ""
        for part in situations_and_answers:
            pdf.set_font("Calibriz", size=9)

            if previous_title != part['title']:
                pdf.set_left_margin(10)
                pdf.set_text_color(28, 176, 235)
                pdf.write(txt=f"{part['title']}")
                pdf.ln()

            pdf.set_left_margin(15)
            pdf.set_text_color(0, 0, 0)
            pdf.cell(w=0,
                     h=data_row_height,
                     txt=f'{part["question"]}',
                     ln=1)

            pdf.set_font("Calibri", size=8)
            pdf.multi_cell(w=0, h=data_row_height - 3, txt=f'{part["answer"]}')
            pdf.ln()
            previous_title = part["title"]

    # WORK MOTIVATION SECTION--------------------------------
    pdf.set_left_margin(10)
    pdf.set_font("Calibriz", size=11)
    pdf.set_text_color(17, 71, 158)
    pdf.cell(w=95, h=data_row_height, txt="Munka Motiváció", ln=0)
    pdf.set_text_color(0, 0, 0)

    work_motivation_completion_date = work_motivation_test_handler.get_latest_completion_date_from_work_motivation_by_username(username)
    if work_motivation_completion_date is not None:
        work_motivation_completion_date = change_date_format(work_motivation_completion_date["date"])
        categories_max_points = work_motivation_test_handler.get_categories_max_points()
        work_motivation_results = work_motivation_test_handler.get_results_for_applicant(username)

        pdf.set_font("Calibrii", size=8)
        pdf.cell(w=95, h=data_row_height, txt=f"Kitöltötte: {work_motivation_completion_date}", ln=1, align="R")
        pdf.ln()

        pdf.set_font("Calibri", size=8)
        for i, category in enumerate(work_motivation_results):
            pdf.cell(w=28,
                     h=data_row_height,
                     txt=f'{category["title"]}',
                     ln=0,
                     border=1)
            pdf.cell(w=10,
                     h=data_row_height,
                     txt=f'{category["cat_score"]} / {categories_max_points[i]["max_point"]}',
                     ln=1 if i > 0 and i % 5 == 4 else 0,
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


def add_fonts(pdf):
    pdf.add_font('Calibri', fname='./static/fonts/Calibri.ttf')
    pdf.add_font('Calibrib', fname='./static/fonts/Calibrib.ttf')
    pdf.add_font('Calibrii', fname='./static/fonts/Calibrii.ttf')
    pdf.add_font('Calibril', fname='./static/fonts/Calibril.ttf')
    pdf.add_font('Calibrili', fname='./static/fonts/Calibrili.ttf')
    pdf.add_font('Calibriz', fname='./static/fonts/Calibriz.ttf')
    return pdf


def change_date_format(date_to_change):
    date_to_change = str(date_to_change).split("-")
    date_to_change = ". ".join(date_to_change) + "."
    return date_to_change
