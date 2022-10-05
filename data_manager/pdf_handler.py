from fpdf import FPDF
from datetime import date

from data_manager import work_motivation_test_handler
from data_manager import user_handler
from data_manager import common_queries
from data_manager import english_test_handler
from data_manager import social_situation_handler


def get_applicant_tests_results_into_pdf(username="", full_name="", email="", applicants=[], multi_applicant=False, date_from="", date_to=""):
    # -----------------------------PDF formatting-------------------------------------
    # PDF A4 width = 210, height = 297

    PDF = set_footer_for_pdf()
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
    pdf.set_left_margin(10)
    pdf.set_right_margin(10)
    data_row_height = 8
    title_height = 8
    current_date = str(date.today()).replace("-", "_")
    applicant_number = 1

    if multi_applicant:
        filename = "Applicants_test_results_"
        pdf.set_title(f"Pályázók Teszt Eredményei")
        current_date = date_from + "_to_" + date_to
        if len(applicants) != 0:
            applicant_number = len(applicants)
    else:
        filename = full_name.replace(" ", "_") + "_"
        pdf.set_title(f"{full_name} Eredmények")

    output_name = f"static/pdf/{filename}{current_date}.pdf"

    applicant_counter = applicant_number
    while applicant_counter > 0:
        # -------------------------------PDF CONTENT---------------------------------------
        if multi_applicant:
            username = applicants[applicant_number - applicant_counter]["username"] if len(applicants) != 0 else ""
            full_name = applicants[applicant_number - applicant_counter]["full_name"] if len(applicants) != 0 else ""
            email = applicants[applicant_number - applicant_counter]["email"] if len(applicants) != 0 else ""

        pdf.image("static/resources/salva_vita_logo.jpg", x=10, y=5, h=20, w=20)

        pdf.set_font("Calibrib", size=16)
        if multi_applicant and len(applicants) == 0:
            pdf.cell(w=0, h=title_height, txt=f"Eredmények", ln=1, align="C")
        else:
            pdf.cell(w=0, h=title_height, txt=f"{full_name} - Eredmények", ln=1, align="C")

        pdf.set_font("Calibriz", size=9)
        pdf.cell(w=0, h=data_row_height - 3, txt=f"{email}", ln=1, align="C")
        pdf.ln()
        pdf.ln()

        # ENGLISH LANGUAGE SECTION--------------------------------
        eng_test_essay_diff_comp_date = english_test_handler.get_english_test_essay_diff_and_completion_date_by_username(
            username)

        if eng_test_essay_diff_comp_date is not None:
            eng_test_question_results = english_test_handler.get_english_test_questions_results_by_username(username)
            difficulty = "Alapfok" if eng_test_essay_diff_comp_date["difficulty"] == "Elementary" else "Középfok" if \
            eng_test_essay_diff_comp_date["difficulty"] == "Intermediate" else "Felső középfok"
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
            pdf.cell(w=0, h=data_row_height,
                     txt=f"Elért pontszám: {correct_answers} / {correct_answers + wrong_answers}",
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
            pdf.set_font("Calibriz", size=11)
            pdf.set_text_color(17, 71, 158)
            pdf.cell(w=95, h=data_row_height, txt=f"Angol nyelvtudás", ln=1)

        # SOCIAL SITUATIONS SECTION--------------------------------
        pdf.set_left_margin(10)
        pdf.set_font("Calibriz", size=11)
        pdf.set_text_color(17, 71, 158)
        pdf.cell(w=95, h=data_row_height, txt="Társasági Szituációk", ln=0)
        pdf.set_text_color(0, 0, 0)

        soc_situations_completion_date = social_situation_handler.get_latest_completion_date_from_social_situation_by_username(
            username)
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

        pdf.ln()

        # WORK MOTIVATION SECTION--------------------------------
        pdf.set_left_margin(10)
        pdf.set_font("Calibriz", size=11)
        pdf.set_text_color(17, 71, 158)
        pdf.cell(w=95, h=data_row_height, txt="Munka Motiváció", ln=0)
        pdf.set_text_color(0, 0, 0)

        work_motivation_completion_date = work_motivation_test_handler.get_latest_completion_date_from_work_motivation_by_username(
            username)
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

        if applicant_counter > 1: pdf.add_page()
        applicant_counter -= 1

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
