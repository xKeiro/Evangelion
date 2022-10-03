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
    for(const answ of answers){
        const id = answ.getAttribute('question-id');
        const value = answ.value;
        await dataHandler.postSocialSituationResults(value, id);
    }
    document.querySelector("main").innerHTML =
            `<div class="alert alert-success" role="alert">${text["A teszted eredménye elküldve!"]}</div>`;
}