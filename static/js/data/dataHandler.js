/* global console */
/* global alert */
/* jshint esversion:11 */

export let dataHandler = {
    getText: async function () {
        "use strict";
        return await apiGet("/api/text");
    },
    postWorkMotivationAsnwers: async function (answers) {
        "use strict";
        return await apiPost("/api/work-motivation", answers);
    },
    patchWorkMotivationQuestionTitle: async function (questionId, questionTitle) {
        "use strict";
        return apiPatch(`/api/work-motivation/question/${questionId}`, questionTitle);
    },
    postEnglishLanguageTestResults: async function (testResults) {
        "use strict";
        return apiPost("/api/english-language", testResults);
    },
    patchEnglishLanguageText: async function (textId, text) {
        "use strict";
        return apiPatch(`/api/english-language/text/${textId}`, text);
    },
    patchEnglishLanguageTextQuestionTitle: async function (questionId, questionTitle) {
        "use strict";
        return apiPatch(`/api/english-language/question/${questionId}`, questionTitle);
    },
    patchEnglishLanguageOption: async function (optionId, option) {
        "use strict";
        return apiPatch(`/api/english-language/option/${optionId}`, option);
    },
    patchEnglishLanguageEssayTopic: async function (essay_topic_id, essay_topic) {
                "use strict";
        return apiPatch(`/api/english-language/essay_topic/${essay_topic_id}`, essay_topic);
    },
    postSocialSituationResults: async function (result) {
        "use strict";
        return apiPost(`/api/social-situation/`, result);
    }
};

export let text = apiGet("/api/text");

async function apiGet(url) {
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
