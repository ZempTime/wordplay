# User Authentication with Devise
*ArchRails #2, Feb. 18, 2014*

I use rbenv. If you're an RVM guy, sorry!


## Basic user authentication

Clone the WordPlay app before it's been touched by devise. In your
terminal:

'''
git clone https://github.com/trenchwarfare/wordplay.git
git checkout vanilla
'''

In your gemfile, add:

'''
gem 'devise', "~> 3.2.2"
'''

Then run in your terminal:

'''
bundle install
'''

To set up Devise inside WordPlay, run in your terminal:

'''
rails g devise:install
'''

Typically, you're going to want to follow the directions devise outputs in your
terminal right now. But since we're using bootstrap, they'll be slightly
different, so you can ignore them and follow these:

Inside config/environments/development.rb, add this line just
before **end**:

'''
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
'''

Now to get nice Bootstrap dismissable notice bars, in app/views/layouts/application.html.erb add:

'''
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
'''

just before <%= yield %> 

We're going to use the Devise-generated User model to store user
information in our database. Run these in your terminal:

'''
   rails g devise user
   rake db:migrate
'''

The preceding commands will automatically generate the necessary routes and pages
for basic user authentication. 

Now Devise is set up. We want users to be able to view the story, but in
order to add to it they must sign up. To do this,

in entries_controller.rb, add this right after line 1:

'''
  before_action :authenticate_user!, except: [:index]
'''

~~The preceding line of code makes sure that a user is signed in~~ I don't need to explain this line of code. It's almost english!

As one final nicety, we're going to add a sign-in/sign-up section to
every page.

in app/views/layouts/application.html.erb, add this right before the
notice bars you added earlier:

'''
<p class="navbar-text pull-right">
<% if user_signed_in? %>
  Logged in as <strong><%= current_user.email %></strong>.
  <%= link_to 'Edit profile', edit_user_registration_path, :class => 'navbar-link' %> |
  <%= link_to "Logout", destroy_user_session_path, method: :delete, :class => 'navbar-link'  %>
<% else %>
  <%= link_to "Sign up", new_user_registration_path, :class => 'navbar-link'  %> |
  <%= link_to "Login", new_user_session_path, :class => 'navbar-link'  %>
<% end %>
'''

Remember to restart your rails server to see the changes!

## Allowing users to sign up/log in via usernames

For this portion of the tutorial, either complete the preceding section
or in your terminal run:

'''
git clone
https://github.com/trenchwarfare/wordplay.git
git checkout basic_user_authentication
'''

