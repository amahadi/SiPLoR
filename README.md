# Single Page Login Registration Using Devise
See it working at https://single-page-signup-signin.herokuapp.com/

## A demo application for single page login registration using devise and without overriding any devise standard controller methods(index, new, show, edit, delete, destroy)

### STEPS of ACHIEVING IT
1. Of course you'll have to install Devise into your app. Also generate the views. It helps to do our favourite task(copy & paste). I am asuming that I don't have tell you to generate a user model or whatever model you want to authenticate with devise. I am using a user model.
1. Generate a controller(in my case I used `dashboards_controller` which can be used as the root directory after authenrication. I used a show method for this task. Set your root path as `root to: 'dashboards#show'` add append `before_action :authenticate_user!` to the `dashboards_controller`. Also it's good to be able to logout. Adding the following code snippet to your views/dashboards/show.html.erb does just that.
   ```
    <h2>Hello <i><%= @user.email %></i></h2>

    <% if user_signed_in? %>
      <li>
        <%= link_to('Logout', destroy_user_session_path, method: :delete) %>
      </li>
    <% else %>
      <li>
        <%= link_to('Login', new_user_session_path)  %>
      </li>
    <% end %>
   ```
1. Now we need a single controller and view to render the registration and login form. Let us create a new controller and view(in my case `contents_controller` and `contents#new`). Now copy and paste(cause we love it) the contents of app/views/users/registrations/new.html.erb and app/views/users/sessions/new.html.erb to app/views/contents/new.html.erb(only if you follow me blindly otherwise different) respectively. Now your views should not find resources. To fix this, add following code to your app/helpers/contents_helper.rb
   ```
    module ContentsHelper
      def resource_name
        :user
      end

      def resource
        @resource ||= User.new
      end

      def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
      end
    end
   ```
1. Now some housekeeping stuffs. First of all generate `RegistrationsController` that inherits `Devise::RegistrationsController` and `SessionsController` that inherits `Devise::SessionsController`. Now configure the routes.rb like the following.
   ```
     Rails.application.routes.draw do
       root to: 'dashboards#show'

       devise_for :users,
                  controllers: {
                      registrations: 'registrations',
                      sessions: 'sessions'
                  }
       resources :contents
     end
   ```
#### Now you are all set to login and register!!! This is that easy!!!! The hard part begins now.
#### You will realize the following cases. I will discuss and show the way to overcome it in the steps to follow.

1. When you log out, you do not get redirected to the `content#new` rather you are redicted to `sessions#new`. To Overcome that add the following code to your `app/controllers/application_controller.rb`
   ```
     protect_from_forgery with: :exception

     private

     def authenticate_user!
       unless user_signed_in?
         redirect_to new_content_path
       end
     end
   ```
1. When there is some sort of failure in logging in, you do not get redirected to the `content#new` rather you are redicted to `sessions#new`. Following steps should overcome it.
   1. Create `lib/custom_failure.rb` and add the following code
      ```
      class CustomFailure < Devise::FailureApp
        def redirect_url
          new_content_path
        end

        def respond
          if http_auth?
            http_auth
          else
            redirect
          end
        end
      end
      ```
   1. Configure the `config/initializers/devise.rb` with the following
      ```
        config.warden do |manager|
          manager.failure_app = CustomFailure
        end
      ```
   1. Now add the library file to the `config/application.rb`
   ```
   config.autoload_paths << Rails.root.join('lib')
   ```
##### AND YOU ARE ALL SET TO GO.
##### I HAVE INTENTIONALLY LEFT THE REGISTRATION CONFIGURATION FOR YOU TO CONFIGURE.
