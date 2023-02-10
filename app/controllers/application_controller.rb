class ApplicationController < ActionController::Base
        #for preventing csrf
        protect_from_forgery with: :exception

        # check first if the user is not logged in, it redirect to login and registration page
        def is_user_logged_in?
            redirect_to "/" if !session[:user_id].present?
        end
end
