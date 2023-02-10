Rails.application.routes.draw do
    # DOCU: This is the routing for logged in / registration page.
    # Triggered by: homepages
    # Last updated at: February 8, 2023
    # Owner: Cris
    get "/", to: "user#index"
    root to: "user#index"
    post "/register", to: "user#register"
    post "/login", to: "user#login"

    # DOCU: This is the wall page for adding and deleting messages and comment.
    # Triggered by: wall pages
    # Last updated at: February 8, 2023
    # Owner: Cris
    
    get "/wall", to: "message#index"
    post "/message_post", to: "message#message_post"
    post "/comment_post", to: "comment#comment_post"
    delete "/message_delete", to: "message#message_delete"
    delete "/comment_delete", to: "comment#comment_delete"
    
    # route for logging out of user.
    get "/logout", to: "message#logout"
end
