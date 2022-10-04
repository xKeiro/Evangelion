import {dataHandler} from "../data/dataHandler.js";

const textPromise = dataHandler.getText();

init()

function init() {
    const button = document.querySelector("#answer-submit");
    button.addEventListener("click", save);
}

async function save() {
    const answers = document.querySelectorAll("textarea");
    const text = await textPromise;
    const result = [];
    for(const answ of answers){
        const id = answ.getAttribute('data-question-id');
        const value = answ.value;
        result.push([id, value])
    }

    const response = await dataHandler.postSocialSituationResults(result);
    if (response) {
        document.querySelector("main").innerHTML =
            `<div class="alert alert-success" role="alert">${text["A teszted eredménye elküldve!"]}</div>`;
    } else {
        sessionStorage.setItem(document.location.pathname, JSON.stringify({"test_results": result}));
        alert(text["Probléme volt az adatok elküldésével, kérlek próbáld meg később!"]);
    }
}