// menu handling
// add toggle listen to it
document.addEventListener("turbo:load", function() {
    let hamburger = document.querySelector("#hamburger");
    hamburger.addEventListener("click", function(event) {
        evevnt.preventDefault();
        let menu = document.querySelector("#navbar-menu");
        menu.classList.toggle("collapse");
    });
    let account = document.querySelector("#account");
    account.addEventListener("click", function(event) {
            event.preventDefault();
            let menu = document.querySelector("#dropdown-menu.dropdown_menu");
            menu.classList.toggle("active");
    });
});
