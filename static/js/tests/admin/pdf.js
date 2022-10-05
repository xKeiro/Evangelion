/* global console */
/* global alert */

/* jshint esversion:11 */

import {dataHandler} from "../../data/dataHandler.js";

const textPromise = dataHandler.getText();
const userPromise = dataHandler.getUsersWithResults();

createUserTable();
initUsernameEmailCheck();


async function initUsernameEmailCheck() {
    "use strict";
    const userNameField = document.querySelector("#username");
    const emailField = document.querySelector("#email");
    userNameField.addEventListener('change', (event) => {
        const emailField = document.querySelector("#email");
        if (event.currentTarget.value === "") {
            emailField.removeAttribute('disabled');
        } else {
            emailField.setAttribute('disabled', '');
        }
    });
    emailField.addEventListener('change', (event) => {
        const userNameField = document.querySelector("#username");
        if (event.currentTarget.value === "") {
            userNameField.removeAttribute('disabled');
        } else {
            userNameField.setAttribute('disabled', '');
        }
    });
}

async function createUserTable() {
    "use strict";
    const text = await textPromise;
    const users = await userPromise;
    const userTableContainer = document.getElementById('user-table-container');
    const table = document.createElement('table');

    table.classList.add('table', 'table-striped', 'mt-5');
    table.innerHTML = `
<thead class="thead-users">
<tr>
    <th>${text["Felhasználónév"]}</th>
    <th>E-mail</th>
    <th>${text["Családnév"]}</th>
    <th>${text["Keresztnév"]}</th>
    <th>${text["Születési idő"]}</th>
    <th>${text["Dátum"]}</th>
    <th class="action-column">PDF</th>
</tr>
</thead>
<tbody>
</tbody>`;
    userTableContainer.appendChild(table);
    for (const user of users) {
        const date = new Date(user.date);
        const birthday = new Date(user.birthday)
        document.querySelector("tbody").innerHTML +=
            `<td>${user.username}</td>
<td>${user.email}</td>
<td>${user["last_name"]}</td>
<td>${user["first_name"]}</td>
<td>${birthday.getFullYear()}-${birthday.getMonth() + 1}-${birthday.getDay()}</td>
<td>${date.getFullYear()}-${date.getMonth() + 1}-${date.getDay()}</td>
<td><form action="/admin/manage_pdf/one_applicant" method="GET" class="form-container"><button class="form-control user-download-button" type="submit" data-username="${user.username}" name="username" value="${user.username}"><i class="bi bi-file-earmark-arrow-down-fill"></i></button></form></td>`;
    }
    // const userDownloadButtons = document.querySelectorAll('.user-download-button');
    // for (const userDownloadButton of userDownloadButtons){
    //     userDownloadButton.addEventListener('click', handleUserDownload);
    // }
}

function handleUserDownload(event) {
    "use strict";
    const username = event.currentTarget.dataset.username;
    dataHandler.sendPdfRequest(username);
}
