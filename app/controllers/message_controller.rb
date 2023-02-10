# Method for checking if the specific field is not empty
include ApplicationHelper

class MessageController < ApplicationController
    # Check first if the user is logged, before doing any actions
    before_action :is_user_logged_in?

    # DOCU: Function that process json object that contains messages and comments
    # Triggered by: (GET) /wall
    # Requires: params - session[:user_id]
    # Optionals: params - session[:first_name] for displaying who is logged in
    # Returns: { status: true/false, result: {content}, error: }
    # Last updated at: Februrary 8, 2023
    # Owner: Cris
    def index
        begin
        # Getting the json object of messages and comments
        @messages = Message.organized_content

        rescue Exception => e
            @messages[:error] = {:exception => e }
        end
    end

    # DOCU: Function that process the posting of message
    # Triggered by: (POST) /message_post
    # Requires: params - user_id, message
    # Optionals: params - N/A
    # Returns: { status: true/false, result: {message_post}, error: }
    # Last updated at: Februrary 8, 2023
    # Owner: Cris
    def message_post
        response_data = { :status => false, :result => {}, :error => nil }
        
        begin
            require_params = validate_fields(params, [:user_id, :message])
    
            if require_params.present?
                # Inserting message content into message table in database
                response_data = Message.message_create(params)             
            else
                response_data[:error] = "Error encountered."
            end

        rescue Exception => e
            response_data[:error] = {:exception => e}
        end
        
        render :json => response_data
    end

    # DOCU: Function that process the deletion of message
    # Triggered by: (POST) /message_delete
    # Requires: params - message_id, message_user_id
    # Optionals: params - N/A
    # Returns: { status: true/false, result: {message_del}, error: }
    # Last updated at: Februrary 8, 2023
    # Owner: Cris
    def message_delete
        response_data = { :status => false, :result => {}, :error => nil }
        
        begin
            require_params = validate_fields(params, [:message_id, :message_user_id])

            raise "Error encountered" if !require_params[:status]

            # Deleting message into message table in database
            response_data = Message.message_delete(params)
            
            raise "Failed to delete message" if !response_data[:status]

        rescue Exception => e
            response_data[:error] = {:exception => e}
        end
        
        render :json => response_data
    end

    # DOCU: This will process the logged out user and deleting session
    def logout
        reset_session
        redirect_to "/"
    end
end
