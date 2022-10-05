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
    initEditMediaTitle();
    initEditQuestion();
    initEditOption();
}


// region -------------------------------------MEDIA TITLE----------------------------------------
function initEditMediaTitle() {
    "use strict";
    const mediaTopicElements = document.querySelectorAll(".media-title");
    for (const mediaTopicElement of mediaTopicElements) {
        mediaTopicElement.addEventListener("click", handleClickOnMediaTitle);
    }
}

function handleClickOnMediaTitle(event) {
    "use strict";
    const parentNode = event.currentTarget.parentNode;
    event.currentTarget.classList.add("d-none");
    const edit_field = document.createElement("textarea");
    edit_field.dataset.mediaId = event.currentTarget.dataset.mediaId;
    edit_field.classList.add("form-control");
    edit_field.value = event.currentTarget.innerText;
    parentNode.insertBefore(edit_field, event.currentTarget);
    edit_field.addEventListener("change", handleMediaTitleChange);
}

async function handleMediaTitleChange(event) {
    "use strict";
    const mediaId = event.currentTarget.dataset.mediaId;
    const essayTopicElement = document.querySelector(`.media-title[data-media-id="${mediaId}"]`);
    let changedText = event.currentTarget.value;
    essayTopicElement.innerHTML = changedText;
    dataHandler.patchSocialSituationMediaTitle(mediaId, {"title": changedText});
    event.currentTarget.remove();
    essayTopicElement.classList.remove("d-none");
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
    const questionTitleElement = event.currentTarget.parentNode.querySelector(".question");
    const questionId = questionTitleElement.dataset.questionId;
    questionTitleElement.innerHTML = questionTitle;
    dataHandler.patchSocialSituationQuestion(questionId, {"question": questionTitle});
    event.currentTarget.remove();
    questionTitleElement.classList.remove("d-none");

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
    inputFieldContainer.classList.add("d-flex", "align-items-center");
    inputFieldContainer.innerHTML = `
<div class="col-8">
    <input class="form-control" value="${event.currentTarget.innerText}">
</div>
<div class="col-2">
  <select class="form-select form-control">
      <option value="true">Correct</option>
      <option value="false">Incorrect</option>
  </select>
</div>
<div class="col-2">
    <button class="btn button-custom form-control" type="submit" data-option-id="${event.currentTarget.dataset.optionId}">Elküldés</button>
</div>`;
    const options = inputFieldContainer.querySelectorAll("option");
    for (const option of options) {
        if (option.value === event.currentTarget.dataset.correct) {
            option.setAttribute('selected', true);
        }
    }
    parentNode.insertBefore(inputFieldContainer, event.currentTarget);
    inputFieldContainer.querySelector("button").addEventListener("click", handleOptionChange);

}

async function handleOptionChange(event) {
    "use strict";
    const inputFieldContainer = event.currentTarget.parentNode.parentNode;
    const option = {
        "option": inputFieldContainer.querySelector("input").value,
        "correct": inputFieldContainer.querySelector("select").value
    };
    const optionId = event.currentTarget.dataset.optionId;
    const inputFieldContainerParent = inputFieldContainer.parentNode;
    const optionElement = inputFieldContainerParent.querySelector(`.option[data-option-id="${optionId}"]`);
    dataHandler.patchEnglishLanguageOption(optionId, option);
    optionElement.innerHTML = option.option;
    optionElement.dataset.correct = option.correct;
    inputFieldContainer.remove();
    optionElement.classList.remove("d-none");
}
