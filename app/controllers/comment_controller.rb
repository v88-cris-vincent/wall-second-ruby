# Method for checking if the specific field is not empty
include ApplicationHelper

class CommentController < ApplicationController
    # Check first if the user is logged, before doing any actions
    before_action :is_user_logged_in?

    # DOCU: Function that process the posting of comment
    # Triggered by: (POST) /comment_post
    # Requires: params - user_id, comment
    # Optionals: params - N/A
    # Returns: { status: true/false, result: {comment_post}, error: }
    # Last updated at: Februrary 8, 2023
    # Owner: Cris
    def comment_post
        response_data = { :status => false, :result => {}, :error => nil }
        
        begin
            require_params = validate_fields(params, [:user_id, :comment])
    
            if require_params.present?
                # Inserting comment content into comment table in database
                response_data = Comment.comment_create(params)
            else
                response_data[:error] = "Error encountered."
            end

        rescue Exception => e
            response_data[:error] = {:exception => e}
        end
        
        render :json => response_data
    end

    # DOCU: Function that process the deletion of comment (Updated comment table in foreign key message id "ON DELETE CASCADE")
    # Triggered by: (POST) /comment_delete
    # Requires: params - message_id, message_user_id
    # Optionals: params - N/A
    # Returns: { status: true/false, result: {comment_del}, error: }
    # Last updated at: Februrary 8, 2023
    # Owner: Cris
    def comment_delete
        response_data = { :status => false, :result => {}, :error => nil }
        
        begin
            require_params = validate_fields(params, [:comment_id, :comment_user_id])

            raise "Error encountered." if !require_params[:status]

            # Deleting comment into comment table in database
            response_data = Comment.comment_delete(params)

            raise "Failed to delete comment." if !response_data[:status]
            
        rescue Exception => e
            response_data[:error] = {:exception => e}
        end
        
        render :json => response_data
    end
end
