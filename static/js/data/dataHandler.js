/* global console */
/* global alert */
/* jshint esversion:11 */

export let dataHandler = {
    getText: async function (){
        "use strict";
        return await apiGet("/api/text");
    },
    postWorkMotivationAsnwers: async function (answers) {
        "use strict";
        return await apiPost("/api/work-motivation", answers);
    },
    patchWorkMotivationQuestionTitle: async function (questionId, questionTitle){
        "use strict";
        return apiPatch(`/api/work-motivation/question/${questionId}`, questionTitle);
    }
};

export let text = apiGet("/api/text");

async function apiGet(url){
    "use strict";
    const response = await fetch(url);
    return await response.json();
}

async function apiPost(url, payload) {
    "use strict";
    const response = await fetch(url, {
        method: "POST",
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
        },
        body: JSON.stringify(payload)
    });
    if (response.ok) {
        return true;
    } else {
        alert("Probléma volt az adatok elküldésénel: " + response);
    }
}

async function apiPatch(url, changedData) {
    "use strict";
    let response = fetch(url, {
        method: "PATCH",
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
        },
        body: JSON.stringify(changedData)
    });
}
