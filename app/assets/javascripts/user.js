$(document).ready( () => {

    /**
    * DOCU: This function is to show if the user is successfully logged in or failed
    * Triggered: .on("submit", "#login_form") <br>
    * Last Updated Date: February 8, 2023
    * @function
    * @memberOf 
    * @author Cris
    */
    $("#login_form").on("submit", function (e) {
        e.preventDefault();
        let form = $(this);

        $.post(form.attr("action"), $(form).serialize(), (data) => {
            if(data.status) {
                window.location = "/wall";
            }
            else {
                alert(data.error);
            }
        }, "");

        return false;
    });

    /**
    * DOCU: This function is to show if the user is successfully created or failed
    * Triggered: .on("submit", "#registration_form") <br>
    * Last Updated Date: February 8, 2023
    * @function
    * @memberOf 
    * @author Cris
    */
    $("#registration_form").on("submit", function () {
        let form = $(this);

        $.post(form.attr("action"), $(form).serialize(), (data) => {
            if(data.status) {
                location.reload();
                alert("Successfully created");
            }
            else {
                alert(data.error);
            }
        }, "json");

        return false;
    });
});