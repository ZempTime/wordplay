# User Authentication with Devise
*ArchRails #2, Feb. 18, 2014*

I use rbenv. If you're an RVM guy, sorry!

To get up and running, use http://gorails.com/setup/osx/10.9-mavericks

## Basic user authentication

Clone the WordPlay app. In your
**terminal**:

```
git clone https://github.com/trenchwarfare/wordplay.git
```

In your **gemfile**, add:

```
gem 'devise', "~> 3.2.2"
```

Then run in your **terminal**:

```
bundle install
```

To set up Devise inside WordPlay, run in your **terminal**:

```
rails g devise:install
```

Typically, you're going to want to follow the directions devise outputs in your
terminal right now. But since we're using bootstrap, they'll be slightly
different, so you can ignore them and follow these:

Inside **config/environments/development.rb**, add this line just
before **end**:

```
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
```

Now to get nice Bootstrap notice bars, in **app/views/layouts/application.html.erb** add:

```
    <% if notice %>
      <div class="temp alert alert-info alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <%= notice %>
      </div>
    <% end %>

    <% if alert %>
      <div class="temp alert alert-warning alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <%= alert %>
      </div>
    <% end %>
```

just before <%= yield %> 

We're going to use the Devise-generated User model to store user
information in our database. Run these in your **terminal**:

```
   rails g devise user
   rake db:migrate
```

The preceding commands will automatically generate the necessary routes and pages
for basic user authentication. 

Now Devise is set up. We want users to be able to view the story, but in
order to add to it they must sign up. To do this,

in **entries_controller.rb**, add this right after line 1:

```
  before_action :authenticate_user!, except: [:index]
```

~~The preceding line of code makes sure that a user is signed in~~ I don't need to explain this line of code. It's almost english!

As one final nicety, we're going to add a sign-in/sign-up section to
every page.

in **app/views/layouts/application.html.erb**, add this right before the
notice bars you added earlier:

```
<p class="navbar-text pull-right">
<% if user_signed_in? %>
  Logged in as <strong><%= current_user.email %></strong>.
  <%= link_to 'Edit profile', edit_user_registration_path, :class => 'navbar-link' %> |
  <%= link_to "Logout", destroy_user_session_path, method: :delete, :class => 'navbar-link'  %>
<% else %>
  <%= link_to "Sign up", new_user_registration_path, :class => 'navbar-link'  %> |
  <%= link_to "Login", new_user_session_path, :class => 'navbar-link'  %>
<% end %>
```

Remember to restart your rails server to see the changes!

## Allowing users to sign up/log in via username or email

First, we're going to need to tell devise to store a username.

In your **terminal**:

```
rails generate migration add_username_to_users username:string:uniq
rake db:migrate

```

Now, we need to tell the Rails to let our forms access and use this new
parameter. In **app/controllers/application_controller.rb**, add the
following to line 3 (after all the other before_filters and such):

```
before_filter :configure_permitted_parameters, if: :devise_controller?
```
Now, still in **app/controllers/ApplicationController**, add this to the
bottom before end:

```
protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
```

We need to create a single attribute that can contain either the
username or the email as the login. In **app/models/user.rb**, add:

```
attr_accessor :login
```

Now we need to tell Devise to use this combined login variable. In **config/initializers/devise.rb**, add the following line in there somewhere:

```
config.authentication_keys = [ :login ]
```

Now we need to tell Devise to check both the username and the email when
it looks in the database. To do this, we're going to override the
default behavior. In **app/models/user.rb**:

```
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end
```

We also want to make sure a user can login in with their uSeRnAmE - case
insensitive. Add this line in **app/models/user.rb**:

```
  validates :username, :uniqueness => { :case_sensitive => false }
```

Since we're going to add a username, we need to change the packaged
Devise views. To get access to these views, in your **terminal**, run:

```
rails generate devise:views
```

Now, we have to modify the views to include the username in 3 places:
when a user signs up, when a user signs in, and when a user edits their
account.

For sign-in, in **sessions/new.html.erb**, DELETE these lines:

```
<p><%= f.label :email %><br />
<%= f.email_field :email %></p>
```

And let's pass in our new two-in-one login variable. Add these lines in
the place of the ones you just deleted:

```
<p><%= f.label :login %><br />
<%= f.text_field :login %></p>
```

For sign-up, in **registrations/new.html.erb**, look for the email form
helpers (f.label :email) and then add these two lines. Don't delete anything:

```
<p><%= f.label :username %><br />
<%= f.text_field :username %></p>
```

Finally, so users can edit their username, add these two lines above the
email form helpers in **registrations/edit.html.erb**:

```
<p><%= f.label :username %><br />
<%= f.text_field :username %></p>
```

One more thing.

in **config/locales/devise.en.yml**, change the error notifications:

```
#FROM
invalid: "Invalid email or password."
#TO
invalid: "Invalid login or password."

#and FROM
not_found_in_database: "Invalid email or password."
#TO
not_found_in_database: "Invalid login or password."

```

Fin!
