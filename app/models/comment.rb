class Comment < ApplicationRecord
    # This is the foreign key of user for who created the message
    belongs_to :user
    # This is the foreign key of message for where comment is created into message
    belongs_to :message
    # This inlude QueryHelper that provides the MySQL query functionality
    include :: QueryHelper

    # DOCU: This will process the inserting of comment into the database
    # Triggered by: CommentController
    # Requires: params - user_id, message_id, comment
    # Returns: { status: true/false, result: { comment_post }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.comment_create(params)
        response_data = { :status => false, :result => {}, :error => nil }
        
        begin
            # This query is for inserting comment data into comment table in the database
            comment_post = query_insert([
                "INSERT INTO comments (user_id,message_id, comment, created_at, updated_at)
                VALUES (?, ?, ?, NOW(), NOW());", params[:user_id], params[:message_id], params[:comment]
            ])

            response_data[:result] = {:comment_id => comment_post}
            response_data[:status] = true

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end

    # DOCU: This will process the deleting of comment into the database
    # Triggered by: CommentController
    # Requires: params - comment_id, comment_user_id
    # Returns: { status: true/false, result: { comment_del }, error }
    # Last updated at: February 8, 2023
    # Owner: Cris, Updated by: N/A
    def self.comment_delete(params)
        response_data = { :status => false, :result => {}, :error => nil }
        
        begin
            # This query is for deleting comment data into comment table in the database
            comment_del = query_delete([
                "DELETE FROM comments where id = ? and user_id = ?", params[:comment_id], params[:comment_user_id]
            ])

            response_data[:result] = comment_del
            response_data[:status] = true

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end
end
