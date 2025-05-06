class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  
  def index 
    matching_users = User.where({}) 
    
    @list_of_users = matching_users 
    
    render({ :template => "users/index" })
  end
  
  def show 
    the_id = params.fetch("id")

    matching_user = User.where({ :id => the_id }) 
    
    @the_user = matching_user.at(0) 
    
    render({ :template => "users/show" })
  end

end
