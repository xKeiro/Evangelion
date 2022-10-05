/* global console */
/* global alert */
/* jshint esversion:11 */

import {dataHandler} from "../../data/dataHandler.js";

initActions();

async function initActions() {
    "use strict";
    initEditEssayTopic();
}


// region ---------------------------------------ESSAY TOPIC----------------------------------------
function initEditEssayTopic() {
    "use strict";
    const essayTopicElements = document.querySelectorAll(".essay-topic");
    for (const essayTopicElement of essayTopicElements) {
        essayTopicElement.addEventListener("click", handleClickOnEssayTopic);
    }
}

function handleClickOnEssayTopic(event) {
    "use strict";
    const parentNode = event.currentTarget.parentNode;
    event.currentTarget.classList.add("d-none");
    const edit_field = document.createElement("textarea");
    edit_field.dataset.essayTopicId = event.currentTarget.dataset.essayTopicId;
    edit_field.classList.add("form-control");
    edit_field.value = event.currentTarget.innerText;
    parentNode.insertBefore(edit_field, event.currentTarget);
    edit_field.addEventListener("change", handleEssayTopicChange);
}

async function handleEssayTopicChange(event) {
    "use strict";
    const essayTopicElement = document.querySelector(`.essay-topic[data-essay-topic-id="${event.currentTarget.dataset.essayTopicId}"]`);
    let changedText = event.currentTarget.value;
    const essayTopicId = essayTopicElement.dataset.essayTopicId;
    essayTopicElement.innerHTML = changedText;
    dataHandler.patchEnglishLanguageEssayTopic(essayTopicId, {"topic": changedText});
    event.currentTarget.remove();
    essayTopicElement.classList.remove("d-none");

}

// endregion
