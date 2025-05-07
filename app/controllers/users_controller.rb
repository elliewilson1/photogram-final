class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  
  def index 
    matching_users = User.where({}).order({ :username => :asc }) 
    
    @list_of_users = matching_users 
    
    render({ :template => "users/index" })
  end
  
  def show
    the_username = params.fetch("username")

    matching_user = User.where({ :username => the_username }) 
    
    @the_user = matching_user.at(0) 

    if @the_user.private? && 
      current_user != @the_user && 
      !FollowRequest.where({
        :sender_id => current_user.id,
        :recipient_id => @the_user.id,
        :status => "accepted"
      }).any?
      redirect_to("/users", { :alert => "You're not authorized for that." })
      return
    end
  
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

  def likes
    the_username = params.fetch("username")

    matching_user = User.where({ :username => the_username }) 
    
    @the_user = matching_user.at(0)
    
    @likes = Like.where({ :fan_id => @the_user.id })

    liked_photo_ids = @likes.pluck(:photo_id)

    @liked_photos = Photo.where({ :id => liked_photo_ids }).order({ :likes_count => :desc })

    @followers = FollowRequest.where({ :recipient_id => @the_user.id,
        :status => "accepted"
    })
    
    @following = FollowRequest.where({
        :sender_id => @the_user.id,
        :status => "accepted"
    })
    render({ :template => "users/likes" })
  end

  def feed
    the_username = params.fetch("username")

    matching_user = User.where({ :username => the_username }) 
    
    @the_user = matching_user.at(0)
    
    @feed = FollowRequest.where({ :sender_id => @the_user.id, :status => "accepted" })

    feed_user_ids = @feed.pluck(:recipient_id)

    feed_photo_ids = Photo.where({ :owner_id => feed_user_ids })

    @feed_photos = Photo.where({ :id => feed_photo_ids }).order({ :likes_count => :desc })

    @followers = FollowRequest.where({ :recipient_id => @the_user.id,
        :status => "accepted"
    })
    
    @following = FollowRequest.where({
        :sender_id => @the_user.id,
        :status => "accepted"
    })
    render({ :template => "users/feed" })
  end
  
  def discover
    the_username = params.fetch("username")
  
    matching_users = User.where({ :username => the_username })
    @the_user       = matching_users.at(0)
  
    feed = FollowRequest.where({
      :sender_id => @the_user.id,
      :status    => "accepted"
    })
    following_user_ids = feed.pluck(:recipient_id)
  
    likes = Like.where({ :fan_id => following_user_ids })
  
    liked_photo_ids = likes.pluck(:photo_id)
  
    @discover_photos = Photo.where({ :id => liked_photo_ids })
                            .order({ :created_at => :desc })
  
    @followers = FollowRequest.where({ 
        :recipient_id => @the_user.id,
        :status => "accepted"
    })
    
    @following = FollowRequest.where({
        :sender_id => @the_user.id,
        :status => "accepted"
    })
    render({ :template => "users/discover" })
  end
end
