class Message < ApplicationRecord
    # This is the foreign key of user for who created the message
    belongs_to :user
    # This is the relationship of message and comment - one to many
    has_many :comments
    # This inlude QueryHelper that provides the MySQL query functionality
    include :: QueryHelper

    # DOCU: Getting data using json object of messages and comments in database
    # Triggered by: MessageController
    # Returns: { status: true/false, result: { content }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.organized_content
        response_data = { :status => false, :result => {}, :error => nil }
            
        begin
            # This query get all messages and comments into json object
            content = query_select_all([
                "SELECT
                    messages.id AS message_id,
                    messages.user_id AS user_id,
                    concat(message_users.first_name, ' ',message_users.last_name) AS message_sender,
                    messages.message AS message,
                    messages.created_at AS created_at,
                        (SELECT
                            json_objectagg(
                                comments.id,
                                json_object(
                                    'user_id', comments.user_id,
                                    'comment_sender', concat(comment_users.first_name, ' ',comment_users.last_name),
                                    'comment', comments.comment,
                                    'created_at', comments.created_at
                                )
                            )
                            FROM comments
                            LEFT JOIN users comment_users on comment_users.id = comments.user_id
                            WHERE messages.id = comments.message_id
                            ORDER BY comments.created_at ASC
                        ) AS comment
                    FROM messages
                    JOIN users message_users on message_users.id = messages.user_id
                    GROUP BY messages.id
                    ORDER BY messages.created_at DESC;"
            ])

            if !content.nil?
                response_data[:result] = content
                response_data[:status] = true
            end

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end

    # DOCU: This will process the inserting of message into the database
    # Triggered by: MessageController
    # Requires: params - user_id, message
    # Returns: { status: true/false, result: { message_post }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.message_create(params)
        response_data = { :status => false, :result => {}, :error => nil }
            
        begin
            # This query is for inserting message data into message table in the database
            message_post = query_insert([
                "INSERT INTO messages (user_id, message, created_at, updated_at)
                VALUES (?, ?, NOW(), NOW());", params[:user_id], params[:message]
            ])


            # if message_post
            #     response_data[:result][:html] = render_to_string :partial => "message_content",
            #         :locals => {
            #             :message => [{
            #                 "message_id" => response_data[:result][:message_id],
            #                 "message_user_id" => session[:user_id],
            #                 "first_name" => session[:first_name],
            #                 "message" => params[:message]
            #             }]
            #         }
                
            # else
            # end

            response_data[:result] = {:message_id => message_post}
            response_data[:status] = true

        rescue Exception => e
            response_data[:error] = e
        end
        
        return response_data
    end

    # DOCU: This will process the deleting of message into the database
    # Triggered by: MessageController
    # Requires: params - message_id, message_user_id
    # Returns: { status: true/false, result: { message_del }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.message_delete(params)
        response_data = { :status => false, :result => {}, :error => nil }
            
        begin
            # This query is for deleting message data into message table in the database
            message_del = query_delete([
                "DELETE FROM messages where id = ? and user_id = ?", params[:message_id], params[:message_user_id]
            ])

            response_data[:result] = message_del
            response_data[:status] = true

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end
end
