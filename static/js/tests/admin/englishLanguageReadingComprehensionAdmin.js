/* global console */
/* global alert */
/* jshint esversion:11 */

import {dataHandler} from "../../data/dataHandler.js";
// import {util} from "./util/util.js";
//
// const language = util("language");

initActions();

async function initActions() {
    "use strict";
    initEditTestText();
    initEditQuestion();
    initEditOption();
}


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

async function initEditQuestion() {
    "use strict";
    const questionElements = document.querySelectorAll(".question");
    for (const questionElement of questionElements) {
        questionElement.addEventListener("click", handleClickOnQuestion);
    }
}

async function handleClickOnQuestion(event) {
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


async function initEditOption() {
    "use strict";
    const optionElements = document.querySelectorAll(".option");
    for (const optionElement of optionElements) {
        optionElement.addEventListener("click", handleClickOnOption);
    }
}

async function handleClickOnOption(event) {
    "use strict";
    const parentNode = event.currentTarget.parentNode;
    event.currentTarget.classList.add("d-none");
    const inputFieldContainer = document.createElement("div");
    inputFieldContainer.classList.add("d-flex");
    inputFieldContainer.innerHTML= `
<div class="col-9">
<input class="form-control" value="${event.currentTarget.innerText}">
</div>
<div class="col-2">
  <select class="form-select">
      <option value="true">Correct</option>
      <option value="false">Incorrect</option>
  </select>
</div>
<div class="col-2">
<button class="btn btn-primary">Elküldés</button>
</div>`;
    const options = inputFieldContainer.querySelectorAll("option");
    for (const option of options){
        if (option.value === event.currentTarget.dataset.correct){
                console.log(event.currentTarget.dataset.correct === option.value);
            option.setAttribute('selected', true);
        }
    }
    parentNode.insertBefore(inputFieldContainer, event.currentTarget);

}

async function handleOptionChange(event) {
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
