# Single Page Login Registration Using Devise
See it working at https://single-page-signup-signin.herokuapp.com/

A demo application for single page login registration using devise and without overriding any devise standard controller methods (index, new, show, edit, delete, destroy)

### STEPS to ACHIEVE IT
1. Of course Devise will have to be installed in the app. Also it's convenient for the developers to generate the views of devise. It helps to do everybody's favourite task (copy & paste). Generate a user model.
1. Generate a controller (in this example `dashboards_controller`) that can be used as the root directory after authentication. It uses a show method for this task. Set the root path as `root to: 'dashboards#show'` and append `before_action :authenticate_user!` to the `dashboards_controller`. Also it's good to be able to logout. Adding the following code snippet to views/dashboards/show.html.erb does just that.
   ```ruby
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
1. Now the app needs a single controller and view to render the registration and login form. Generate a new controller and view (in this example `contents_controller` and `contents#new`). Now copy and paste (cause we love it) the contents of `app/views/users/registrations/new.html.erb` and `app/views/users/sessions/new.html.erb` to `app/views/contents/new.html.erb` (only if you follow me blindly otherwise different) respectively. Now the views should not find resources. To fix this, add following code to `app/helpers/contents_helper.rb`
   ```ruby
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
1. Now some housekeeping stuffs. First of all generate `RegistrationsController` that inherits `Devise::RegistrationsController` and `SessionsController` that inherits `Devise::SessionsController`. Configure the routes.rb like the following.
   ```ruby
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
#### And it is all set to login and register!!! This is that easy!!!! The hard part begins now.
#### The following cases should be realized. These are discussed and the way to overcome them are shown in the steps to follow.

1. When user logs out, the browser does not get redirected to the `content#new` rather it is redicted to `sessions#new`. To Overcome that add the following code to your `app/controllers/application_controller.rb`
   ```ruby
   protect_from_forgery with: :exception

   private

   def authenticate_user!
     unless user_signed_in?
       redirect_to new_content_path
     end
   end
   ```
1. When there is some sort of failure in login process, it does not get redirected to the `content#new` rather it is redicted to `sessions#new`. Following steps should overcome it.
   1. Create `lib/custom_failure.rb` and add the following code
      ```ruby
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
      ```ruby
      config.warden do |manager|
         manager.failure_app = CustomFailure
      end
      ```
   1. Lastly, add the library file to the `config/application.rb`
      ```ruby
      config.autoload_paths << Rails.root.join('lib')
      ```
##### AND YOU ARE ALL SET TO GO.
##### I HAVE INTENTIONALLY LEFT THE REGISTRATION CONFIGURATION FOR YOU TO CONFIGURE.
