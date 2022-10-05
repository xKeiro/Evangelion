/* global console */
/* global alert */

/* jshint esversion:11 */

initUsernameEmailCheck();

async function initUsernameEmailCheck() {
    "use strict";
    const userNameField = document.querySelector("#username");
    const emailField = document.querySelector("#email");
    userNameField.addEventListener('change', (event) => {
        const emailField = document.querySelector("#email");
        console.log("szia")
        if (event.currentTarget.value === "") {
            emailField.removeAttribute('disabled');
        } else {
            emailField.setAttribute('disabled', '');
        }
    });
    emailField.addEventListener('change', (event) => {
        const userNameField = document.querySelector("#username");
        console.log("szia")
        if (event.currentTarget.value === "") {
            userNameField.removeAttribute('disabled');
        } else {
            userNameField.setAttribute('disabled', '');
        }
    });
}
