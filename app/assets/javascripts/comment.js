$(document).ready( () => {
    
    /**
    * DOCU: This function is to show if the comment is successfully created or failed
    * Triggered: .on("submit", "#comment_post") <br>
    * Last Updated Date: February 8, 2023
    * @function
    * @memberOf 
    * @author Cris
    */
    $("#comment_post").on("submit", function () {
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
    * DOCU: This function is to show if the comment is successfully deleted or failed
    * Triggered: deleteComment <br>
    * Last Updated Date: February 8, 2023
    * @function
    * @memberOf 
    * @author Cris
    */
    $("#comment_delete").on("submit", function () {
        let form = $(this);

        $.post(form.attr("action"), $(form).serialize(), (data) => {
            if(data.status) {
                location.reload();
                alert("Successfully delete a comment");
            }
            else {
                alert(data.error);
            }
        }, "json");

        return false;
    });

    /**
    * DOCU: This function is to  passed the data to comment form
    * Triggered: $(".delete_comment_btn").on("click") <br>
    * Last Updated Date: February 8, 2023
    * @function
    * @memberOf 
    * @author Cris
    */
    $(".delete_comment_btn").on("click", deleteComment);
});

/**
* DOCU: This function is to process the passing of data to comment form
* Triggered: $(".delete_comment_btn").on("click") <br>
* Last Updated Date: February 8, 2023
* @function
* @memberOf 
* @author Cris
*/
function deleteComment(){
    let comment_id = $(this).attr("data-comment_id");
    let comment_user_id = $(this).attr("data-comment_user_id");

    $(".comment_id_del").val(comment_id);
    $(".comment_user_id_del").val(comment_user_id);
    $("#comment_delete").submit();

    $(".comment_id_del").val();
    $(".comment_user_id_del").val();
};