/* global console */
/* global alert */
/* global confirm */
/* jshint esversion:11 */

import {dataHandler} from "../data/dataHandler.js";

const textPromise = dataHandler.getText();

init();

function init() {
    "use strict";
    const button = document.querySelector("#answer-submit");
    button.addEventListener("click", save);
}

async function save() {
    "use strict";
    const answers = document.querySelectorAll("textarea");
    const text = await textPromise;
    const result = [];
    let is_everything_answered = true;
    for (const answ of answers) {
        const id = answ.getAttribute('data-question-id');
        const value = answ.value;
        if (value.length === "") {
            alert(text["Kérlek válaszolj az összes kérdésre elküldés előtt!"]);
            is_everything_answered = false;
            break;
        }
        result.push([id, value]);
    }
    if (is_everything_answered) {
        const response = await dataHandler.postSocialSituationResults(result);
        if (response) {
            document.querySelector("main").innerHTML =
                `<div class="alert alert-success" role="alert">${text["A teszted eredménye elküldve!"]}</div>`;
        } else {
            sessionStorage.setItem(document.location.pathname, JSON.stringify({"test_results": result}));
            alert(text["Probléme volt az adatok elküldésével, kérlek próbáld meg később!"]);
        }
    }
}
