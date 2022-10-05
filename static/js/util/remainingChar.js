const max = 2000;
const textarea = document.querySelector('textarea');
let info = document.querySelector('#characters');

//Init the count for the first time
info.textContent = max - textarea.value.length;

textarea.addEventListener('input', function () {
    info.textContent = max - this.value.length;
})
