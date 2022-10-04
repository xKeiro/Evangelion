/* global console */
/* global alert */
/* jshint esversion:11 */

import {dataHandler} from "../../data/dataHandler.js";
// import {util} from "./util/util.js";
//
// const language = util("language");
initEditTestText();

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
    edit_field.rows="26";
    edit_field.value = event.currentTarget.innerText;
    parentNode.insertBefore(edit_field, event.currentTarget);
    edit_field.addEventListener("change",handleTestTextChange);
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
