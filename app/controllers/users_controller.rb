class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  
  def index 
    matching_users = User.where({}).order({ :username => :asc }) 
    
    @list_of_users = matching_users 
    
    render({ :template => "users/index" })
  end
  
  def show 
    the_id = params.fetch("id")

    matching_user = User.where({ :id => the_id }) 
    
    @the_user = matching_user.at(0)
    
    @pending_follow_requests = FollowRequest.where({
        :recipient_id => @the_user.id,
        :status       => "pending"
    })

    @own_photos = Photo.where({
        :owner_id => @the_user.id
    }).order({ :likes_count => :desc })
    
    @followers = FollowRequest.where({ :recipient_id => @the_user.id,
        :status => "accepted"
    })
    
    @following = FollowRequest.where({
        :sender_id => @the_user.id,
        :status => "accepted"
    })
    
    render({ :template => "users/show" })
  end

end
