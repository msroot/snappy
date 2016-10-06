class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
end


# rails g scaffold event description:text name start_time:datetime end_time:datetime  page:references place:references fb_id
# rails g scaffold place name location:references fb_id
# rails g scaffold page name  fb_id