/* global console */
/* global alert */
/* jshint esversion:11 */
import {dataHandler} from "../data/dataHandler.js";
import {convertMapToObject} from "../util/util.js";

// document.cookie = "language=en;path=/";

const NUMBER_OF_QUESTIONS = document.querySelectorAll(".question-row").length;
const answers = new Map();
const textPromise = dataHandler.getText();
initActions();

function initActions(){
    "use strict";
    initClickForQuestions();
    initClickForQuestionSubmit();
}


async function initClickForQuestions() {
    "use strict";
    const questionRowElements = document.querySelectorAll(".question-row");
    for (const questionRowElement of questionRowElements) {
        const questionButtons = questionRowElement.querySelectorAll(`.option-button`);
        const questionId = questionRowElement.dataset.questionId;
        for (const questionButton of questionButtons) {
            questionButton.addEventListener("click", (event) => {
                selectAnswer(event, questionId);
            });
        }

    }
}

async function initClickForQuestionSubmit() {
    "use strict";
    const submitButton = document.getElementById("question-submit");
    submitButton.addEventListener("click", submitAnswers);
}

async function submitAnswers() {
    "use strict";
    const text = await textPromise;
    if (NUMBER_OF_QUESTIONS === answers.size) {
        const response = await dataHandler.postWorkMotivationAsnwers( convertMapToObject(answers));
        if (response){

            document.querySelector("main").innerHTML =
                `<div class="alert alert-success" role="alert">${text["A teszted eredménye elküldve!"]}</div>`;
        }
    } else {
        alert(text["Kérlek válaszolj az összes kérdésre elküldés előtt!"]);
    }
}

async function selectAnswer(event, questionId) {
    "use strict";
    event.currentTarget.classList.add('selected');
    const selectedScore = event.currentTarget.innerText;
    answers.set(questionId, selectedScore);
    const currentQuestionButtons = document.querySelectorAll(`.question-row[data-question-id="${questionId}"] input[type="radio"]`);
    for (const currentQuestionButton of currentQuestionButtons) {
        if (currentQuestionButton.innerHTML !== selectedScore) {
            currentQuestionButton.classList.remove("selected");
        }
    }
}
