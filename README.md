# Single Page Login Registration Using Devise

**A demo application for single page login registration using devise and without overriding any devise standard controller methods(index, new, show, edit, delete, destroy)**

**STEPS of ACHIEVING IT**
1. Of course you'll have to install Devise into your app. Also generate the views. It helps to do our favourite task(copy & paste). I am asuming that I don't have tell you to generate a user model or whatever model you want to authenticate with devise. I am using a user model.
1. Generate a controller(in my case I used dashboards_controller) which can be used as the root directory after authenrication. I used a show method for this task. Set your root path as `root to: 'dashboards#show'`. Also it's good to be able to logout. Adding the following code snippet to your views/dashboards/show.html.erb does just that.
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
