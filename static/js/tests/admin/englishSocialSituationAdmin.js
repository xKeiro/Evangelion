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
    initEditMedia();
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


async function initEditMedia() {
    "use strict";
    const mediaElements = document.querySelectorAll(".media-edit");
    for (const mediaElement of mediaElements) {
        mediaElement.addEventListener("click", handleClickOnMedia);
    }
}

async function handleClickOnMedia(event) {
    "use strict";
    const parentNode = event.currentTarget.parentNode;
    const mediaId = event.currentTarget.dataset.mediaId;
    const mediaType = event.currentTarget.dataset.mediaType;
    const mediaValue = mediaType === "video" ? event.currentTarget.innerText : event.currentTarget.src;
    event.currentTarget.classList.add("d-none");
    const inputFieldContainer = document.createElement("div");
    inputFieldContainer.classList.add("d-flex", "align-items-center");
    inputFieldContainer.innerHTML = await constructMediaInputHtmlByType(mediaId, mediaType, mediaValue) ;
    parentNode.insertBefore(inputFieldContainer, event.currentTarget);
    inputFieldContainer.querySelector('select').addEventListener('change', handleMediaTypeChange);
    inputFieldContainer.querySelector('button').addEventListener("click", handleMediaChange);

}

async function constructMediaInputHtmlByType( mediaId, mediaType, mediaValue){
    "use strict";
    let media_html;
    switch (mediaType){
        case "image":
            media_html = `
    <div class="col-8">
        <input type="file" class="form-control" data-media-id="${mediaId}" value="${mediaValue}">
    </div>
    <div class="col-2">
        <select class="form-select form-control" data-media-id="${mediaId}">
            <option value="image" selected>Image</option>
            <option value="video">Video</option>
        </select>
    </div>
    <div class="col-2">
        <button class="btn button-custom form-control" type="submit" data-media-id="${mediaId}">Elküldés</button>
    </div>`;
            break;
        case "video":
            media_html = `
<div class="col-8">
    <input class="form-control" data-media-id="${mediaId}" value="${mediaValue}">
</div>
<div class="col-2">
  <select class="form-select form-control" data-media-id="${mediaId}">
      <option value="image">Image</option>
      <option value="video" selected>Video</option>
  </select>
</div>
<div class="col-2">
    <button class="btn button-custom form-control" type="submit" data-media-id="${mediaId}">Elküldés</button>
</div>`;
            break;
    }
    return media_html;
}

async function handleMediaTypeChange(event){
    "use strict";
    const mediaId = event.currentTarget.dataset.mediaId;
    const mediaType = event.currentTarget.value;
    const mediaInputContainer = event.currentTarget.parentNode.parentNode;
    const currentInputElement = mediaInputContainer.querySelector("input");
    switch (mediaType){
        case 'image':
            currentInputElement.type="file";
            break;
        case 'video':
            currentInputElement.type="text";
            break;
    }
}

async function handleMediaChange(event) {
    "use strict";
    const inputFieldContainer = event.currentTarget.parentNode.parentNode;
    // const option = {
    //     "option": inputFieldContainer.querySelector("input").value,
    //     "correct": inputFieldContainer.querySelector("select").value
    // };
    const mediaType = inputFieldContainer.querySelector("select").value;
        switch (mediaType) {
            case 'image':
                handleImageChange( inputFieldContainer);
                break;
            case 'video':
                handleVideoChange( inputFieldContainer);
                break;
        }
}


async function handleVideoChange(inputFieldContainer){
    "use strict";
    const url = inputFieldContainer.querySelector('input').value;
    const mediaId = inputFieldContainer.querySelector('input').dataset.mediaId;
    if (url.includes("https://www.youtube.com/watch?v=")){
        await dataHandler.patchSocialSituationMediaToVideo(mediaId, {"url": url, "type": "video"});
        location.reload();
    }else{
        alert("Az videó linkeknek tartalmaznia kell hogy: https://www.youtube.com/watch?v=");
    }

}

async function handleImageChange(inputFieldContainer){
    "use strict";
    const files = inputFieldContainer.querySelector('input').files;
    const fileName = files[0].name;
    const mediaId = inputFieldContainer.querySelector('input').dataset.mediaId;
    const media = new FormData();
    media.append('image', files[0]);
    media.append('fileName', fileName);
    await dataHandler.patchSocialSituationMediaToImage(mediaId, media);
    location.reload();
    }
