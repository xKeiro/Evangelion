/* global console */
/* global alert */
/* jshint esversion:11 */

import {dataHandler} from "../../data/dataHandler.js";
// import {util} from "./util/util.js";
//
// const language = util("language");
initEditContent();

function initEditContent() {
    "use strict";
    const questionElements = document.querySelectorAll(".question");
    for (const questionElement of questionElements) {
        const questionTitleElement = questionElement.querySelector("p");
        questionTitleElement.addEventListener("click", handleClickOnQuestion);
    }
}

function handleClickOnQuestion(event) {
    "use strict";
    const parentNode = event.currentTarget.parentNode;
    event.currentTarget.classList.add("d-none");
    const edit_field = document.createElement("input");
    edit_field.classList.add("form-control");
    edit_field.value = event.currentTarget.innerText;
    parentNode.insertBefore(edit_field, event.currentTarget);
    edit_field.addEventListener("change",handleQuestionChange);
}

async function handleQuestionChange(event) {
    "use strict";
    const questionTitleElement = event.currentTarget.parentNode.querySelector("p");
    let questionTitle = event.currentTarget.value;
    const questionId = event.currentTarget.parentNode.parentNode.dataset.questionId;
    questionTitleElement.innerHTML = questionTitle;
    dataHandler.patchWorkMotivationQuestionTitle(questionId, {"title": questionTitle});
    event.currentTarget.remove();
    questionTitleElement.classList.remove("d-none");

}
