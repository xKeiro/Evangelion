/* global console */
/* global alert */
/* jshint esversion:11 */

import {dataHandler} from "../../data/dataHandler.js";
// import {util} from "./util/util.js";
//
// const language = util("language");
initEditTestText();
initEditQuestion();


// region ---------------------------------------TEXT----------------------------------------
function initEditTestText() {
    "use strict";
    const testText = document.querySelector(".english-test-text");
    testText.addEventListener("click", handleClickOnTestText);
}

function handleClickOnTestText(event) {
    "use strict";
    const parentNode = event.currentTarget.parentNode;
    event.currentTarget.classList.add("d-none");
    const edit_field = document.createElement("textarea");
    edit_field.classList.add("form-control");
    edit_field.rows = "26";
    edit_field.value = event.currentTarget.innerText;
    parentNode.insertBefore(edit_field, event.currentTarget);
    edit_field.addEventListener("change", handleTestTextChange);
}

async function handleTestTextChange(event) {
    "use strict";
    const testText = document.querySelector(".english-test-text");
    let changedText = event.currentTarget.value;
    const testTextId = testText.dataset.textId;
    testText.innerHTML = changedText;
    dataHandler.patchEnglishLanguageText(testTextId, {"text": changedText});
    event.currentTarget.remove();
    testText.classList.remove("d-none");

}

// endregion
// region --------------------------------------QUESTION----------------------------------------

function initEditQuestion() {
    "use strict";
    const questionElements = document.querySelectorAll(".question");
    for (const questionElement of questionElements) {
        questionElement.addEventListener("click", handleClickOnQuestion);
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
    edit_field.addEventListener("change", handleQuestionChange);
}

async function handleQuestionChange(event) {
    "use strict";
    const questionTitle = event.currentTarget.value;
    if (questionTitle.includes("............")){
        const questionTitleElement = event.currentTarget.parentNode.querySelector(".question");
        const questionId = questionTitleElement.dataset.questionId;
        questionTitleElement.innerHTML = questionTitle;
        dataHandler.patchEnglishLanguageTextQuestionTitle(questionId, {"title": questionTitle});
        event.currentTarget.remove();
        questionTitleElement.classList.remove("d-none");
    }else{
        alert("A kérdésnek tartalmaznia kell: ............");
    }


}

// endregion
// region --------------------------------------OPTION----------------------------------------


// endregion
