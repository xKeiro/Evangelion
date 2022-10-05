/* global console */
/* global alert */

/* jshint esversion:11 */

export function convertMapToObject(map) {
    "use strict";
    const obj = Object.fromEntries(map);
    return obj;
}

export function util(cname) {
    "use strict";
    let name = cname + "=";
    let decodedCookie = decodeURIComponent(document.cookie);
    let ca = decodedCookie.split(';');
    for (let i = 0; i < ca.length; i++) {
        let c = ca[i];
        while (c.charAt(0) === ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) === 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}
