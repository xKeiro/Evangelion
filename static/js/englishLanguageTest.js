/* global console */
/* global alert */
/* global confirm */
/* jshint esversion:11 */

import {convertMapToObject} from "./util/util.js";
import {dataHandler} from "./data/dataHandler.js";

const NUMBER_OF_QUESTIONS = document.querySelectorAll('.question-card').length;
let answers = new Map();
const textPromise = dataHandler.getText();
initEvents();

async function initEvents() {
    "use strict";
    console.log(sessionStorage)
    if (sessionStorage.getItem(document.location.pathname)) {
        const stored_data = JSON.parse(sessionStorage.getItem(document.location.pathname));
        if ("test_results" in stored_data) {
            const text = await textPromise;
            sendTest(stored_data.test_results);
        } else if ("answers" in stored_data) {
            answers = stored_data.answers;
            console.log(answers);
            hideQuestionsAndShowEssay();
            initSendEnglishLanguageTest();
        }

    } else {
        initRadioButtonChange();
        initChangingToEssay();
        initSendEnglishLanguageTest();
    }

}


async function initRadioButtonChange() {
    "use strict";
    const radioInputs = document.querySelectorAll(`input[type="radio"]`);
    for (const radioInput of radioInputs) {
        radioInput.addEventListener('change', handleRadioButtonValueChange);
    }
}

async function initChangingToEssay() {
    "use strict";
    const submitButton = document.querySelector('#question-submit');
    submitButton.addEventListener('click', handleChangingToEssay);
}

async function initSendEnglishLanguageTest() {
    "use strict";
    const submitButton = document.querySelector('#test-submit');
    submitButton.addEventListener('click', handleSendEnglishLanguageTest);
}

async function handleRadioButtonValueChange(event) {
    "use strict";
    answers.set(event.currentTarget.dataset.questionId, event.currentTarget.dataset.optionId);
}

async function handleChangingToEssay() {
    "use strict";
    const text = await textPromise;
    if (answers.size === NUMBER_OF_QUESTIONS) {
        const isConfirmed = confirm(text["Biztos tovább szeretnél lépni?"]);
        if (isConfirmed) {
            hideQuestionsAndShowEssay();
            sessionStorage.setItem(document.location.pathname, JSON.stringify({"answers": convertMapToObject(answers)}));
            window.scrollTo(0, 0);
        }
    } else {
        alert(text["Kérlek válaszolj az összes kérdésre elküldés előtt!"]);
    }
}


async function handleSendEnglishLanguageTest() {
    "use strict";
    const text = await textPromise;
    const isConfirmed = confirm(text["Biztos tovább szeretnél lépni?"]);
    if (isConfirmed) {
        const essayElement = document.querySelector('#essay');
        const essay = {"essay": essayElement.value, "topic_id": essayElement.dataset.essayId};
        if (answers.constructor === Map) {
            answers = convertMapToObject(answers);
        }
        const testResults = {"answers": Object.values(answers), "essay": essay};
        await sendTest(testResults, text);
    }
}

async function sendTest(testResults, text) {
    "use strict";
    const response = await dataHandler.postEnglishLanguageTestResults(testResults);
    if (response) {
        sessionStorage.removeItem(document.location.pathname);
        document.querySelector("main").innerHTML =
            `<div class="alert alert-success" role="alert">${text["A teszted eredménye elküldve!"]}</div>`;
    } else {
        sessionStorage.setItem(document.location.pathname, JSON.stringify({"test_results": testResults}));
        alert(text["Probléme volt az adatok elküldésével, kérlek próbáld meg később!"]);
    }
}

async function hideQuestionsAndShowEssay() {
    "use strict";
    document.querySelector("#reading-comprehension").classList.add("d-none");
    document.querySelector("#essay-writing").classList.remove("d-none");
}
