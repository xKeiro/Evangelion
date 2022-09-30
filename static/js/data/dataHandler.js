/* global console */
/* global alert */
/* jshint esversion:11 */

export let dataHandler = {
    postWorkMotivationAsnwers: async function (answers) {
        "use strict";
        return await apiPost("/api/work-motivation", answers);
    }
};

async function apiPost(url, payload) {
    "use strict";
    let response = await fetch(url, {
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
