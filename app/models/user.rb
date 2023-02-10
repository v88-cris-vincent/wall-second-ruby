class User < ApplicationRecord
    # This inlude QueryHelper that provides the MySQL query functionality
    include :: QueryHelper
    # This validates if the password and email is pressenced
    validates :password, :email, presence: true

    # DOCU: Getting single user data in database based on email address
    # Triggered by: UserController
    # Requires: params - email_address
    # Returns: { status: true/false, result: { user_get_query }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.user_get(params)
        response_data = { :status => false, :result => {}, :error => nil }
           
        begin
            user_get_query = query_select_one([
                "SELECT * FROM users WHERE email = ?;", params[:email_address]
            ])

            if user_get_query.length
                response_data[:result] = user_get_query
                response_data[:status] = true
            end

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end

    # DOCU: This will process inserting user data into database if the validation successful
    # Triggered by: UserController
    # Requires: params - first_name, last_name, email_address, password
    # Returns: { status: true/false, result: { user_insert }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.user_create(params)
        response_data = { :status => false, :result => {}, :error => nil }
        begin

            # This will process the validation of user data
            validate_params = self.validate_users_data(params)
            if validate_params[:status]
                get_id = query_select_one([
                    "SELECT id from users WHERE email = ?;", validate_params[:result][:email_address]
                ])
                
                if !get_id
                    
                    # This will converting password into MD5 format for security purposes
                    validate_params[:result][:password] = Digest::MD5.hexdigest(validate_params[:result][:password])
                    
                    query_params = validate_params[:result]  
                    #This will inserting user data into the user table in the database                  
                    user_insert = query_insert([
                        "INSERT INTO users (first_name, last_name, email, password, created_at, updated_at)
                        VALUE (?, ?, ?, ?, NOW(), NOW());", query_params[:first_name], query_params[:last_name], query_params[:email_address], query_params[:password],
                    ])
                    
                    if user_insert > 0            
                        response_data[:result] = {:user_id => user_insert}
                        response_data[:status] = true
                    else
                        response_data[:error] = "Not successfully created, please try again."
                    end

                else
                    response_data[:error] = "Email address registered. Please try another one."
                end

            else
                response_data[:error] = validate_params[:error]
            end
            
        rescue Exception => e
            response_data[:error] = e
        end
        
        return response_data
    end

    # DOCU: This will process the authentication if email and password are match then geting of id, first name and last name in user table
    # Triggered by: UserController
    # Requires: params - email_address, password
    # Returns: { status: true/false, result: { user_get_query }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.user_authenticate(params)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            user_get_query = query_select_one([
                "SELECT id, first_name, last_name FROM users WHERE email = ? AND password = ?;", params[:email_address], Digest::MD5.hexdigest(params[:password])
            ])

            unless user_get_query.nil?
                response_data[:result] = user_get_query
                response_data[:status] = true
            end

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data             
    end

    private

    # DOCU: This will process the validation of data in registration of user
    # Triggered by: User
    # Requires: params - first_name, last_name, email_address, password
    # Returns: { status: true/false, result: { user_data }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.validate_users_data(user_data)
        response_data = { :status => false, :result => {}, :error => "" }

            response_data[:error] << "First Name has special characters." if user_data[:first_name] =~ /[@%^&!"\\\*\.,\-\:?\/\'=`{}()+_\]\|\[\><~;$#0-9]/

            response_data[:error] << "Last Name has special characters." if user_data[:last_name] =~ /[@%^&!"\\\*\.,\-\:?\/\'=`{}()+_\]\|\[\><~;$#0-9]/        

            # response_data[:error] << "Email Address not in correct format." if user_data[:email_address] !=~ /\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/

            response_data[:error] << "Password too short. Need at least 8 characters." if user_data[:password].length < 8

            response_data[:error] << "Password and Confirm Password are not the same." if user_data[:password] != user_data[:confirm_password]

        if response_data[:error].empty?
            response_data[:status] =true
            response_data[:result] = user_data
        end

        return response_data
    end
end
