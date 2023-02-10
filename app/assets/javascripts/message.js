$(document).ready( () => {

    /**
    * DOCU: This function is to show if the message is successfully created or failed
    * Triggered: .on("submit", "#message_post") <br>
    * Last Updated Date: February 8, 2023
    * @function
    * @memberOf 
    * @author Cris
    */
    $("#message_post").on("submit", function (e) {
        e.preventDefault();
        let form = $(this);

        $.post(form.attr("action"), $(form).serialize(), (data) => {
            if(data.status) {
                location.reload();
                alert("Successfully post a comment");
            }
            else {
                alert(data.error);
            }
        }, "json");

        return false;
    });


    /**
    * DOCU: This function is to show if the message is successfully deleted or failed
    * Triggered: deleteMessage <br>
    * Last Updated Date: February 8, 2023
    * @function
    * @memberOf 
    * @author Cris
    */
    $("#message_delete").on("submit", function (e) {
        e.preventDefault();
        let form = $(this);

        $.post(form.attr("action"), $(form).serialize(), (data) => {
            if(data.status) {
                location.reload();
                alert("Successfully delete a message");
            }
            else {
                alert(data.error);
            }
        }, "json");

        return false;
    });

    /**
    * DOCU: This function is to  passed the data to message form
    * Triggered: $(".delete_message_btn").on("click") <br>
    * Last Updated Date: February 8, 2023
    * @function
    * @memberOf 
    * @author Cris
    */
    $(".delete_message_btn").on("click", deleteMessage);
});

/**
* DOCU: This function is to process the passing of data to message form
* Triggered: $(".delete_message_btn").on("click") <br>
* Last Updated Date: February 8, 2023
* @function
* @memberOf 
* @author Cris
*/
function deleteMessage(){
    let message_id = $(this).attr("data-message_id");
    let message_user_id = $(this).attr("data-message_user_id");

    $(".message_id_del").val(message_id);
    $(".message_user_id_del").val(message_user_id);
    $("#message_delete").submit();

    $(".message_id_del").val();
    $(".message_user_id_del").val();
};