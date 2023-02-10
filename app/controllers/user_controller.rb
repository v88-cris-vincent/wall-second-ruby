# Method for checking if the specific field is not empty
include ApplicationHelper

class UserController < ApplicationController
    # Check first if the user is logged, before doing any actions
    before_action :session_exists?

    def index
    end

    # DOCU: Function that process user registration
    # Triggered by: (POST) /register
    # Requires: params - first_name, last_name, email_address, password 
    # Optionals: params - confirm_password for validation only
    # Returns: { status: true/false, result: {user_insert}, error: }
    # Last updated at: Februrary 8, 2023
    # Owner: Cris
    def register
        response_data = { :status => false, :result => {}, :error => nil }
      
        begin
            require_params = validate_fields(params, ["first_name", "last_name", "email_address", "password"])

            if require_params[:status]
                # Check if the email address is existing
                user = User.user_get(params[:email_address])

                if user[:status] && user[:result].length
                    response_data[:error] = "Email Address already exists."
                # Check if password and confirm password are the same
                elsif params[:password] != params[:confirm_password]
                    response_data[:error] = "Password and Confirm Password does not match."
                # User creation into database
                else
                    response_data = User.user_create(params)
                end
                
            else
                response_data[:error] = require_params[:error]
            end

        rescue Exception => e
            response_data[:error] = {:exception => e}            
        end
        
        render :json => response_data
    end

    # DOCU: Function that process user logged in
    # Triggered by: (POST) /login
    # Requires: params - email_address, password 
    # Optionals: params - N/A
    # Returns: { status: true/false, result: {user_get_query}, error: }
    # Last updated at: Februrary 8, 2023
    # Owner: Cris
    def login
        response_data = { :status => false, :result => {}, :error => nil }
     
        begin
            require_params = validate_fields(params, [:email_address, :password])
      
            if require_params.present?
                # Authenticate if the email address and password are match into the database
                user = User.user_authenticate({"email_address": params[:email_address], "password": params[:password]})
    
                # Storing user data into session after successful login
                if user[:status] && user[:result].length
                    response_data[:status] = user[:status]
                    session[:user_id] = user[:result]["id"]
                    session[:first_name] = user[:result]["first_name"]
                    session[:last_name] = user[:result]["last_name"]
                else
                    response_data[:status] = false
                    response_data[:error] = "Incorrect Email / Password, please try again."
                end

            else            
                response_data[:result] = require_params
                response_data[:error] = "Please fill up the missing fields."
            end

        rescue Exception => e
            response_data[:error] = {:exception => e}            
        end
      
        render :json => response_data
    end

    # Function that check if the user is logged in and he redirect to the wall page
    def session_exists?
        redirect_to "/wall" if session[:user_id].present?
    end
end
