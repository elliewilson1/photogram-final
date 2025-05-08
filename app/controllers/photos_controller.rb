class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  def index
    public_user_ids = User.where({ :private => false }).map do |u|
      u.id
    end

    matching_photos = Photo.where({ :owner_id => public_user_ids })
  
    @list_of_photos = matching_photos.order({ :created_at => :desc })
  
    render({ :template => "photos/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

    # all likes and comments

    likes = Like.where({ :photo_id => @the_photo.id })

    fan_user_ids = likes.pluck(:fan_id)

    @list_of_fan_names = User.where({ :id => fan_user_ids })

    @comments = Comment.where({ :photo_id => @the_photo.id }).order({ :created_at => :asc })

    @comments_count = @comments.count

    # likes and comments by the logged-in user

    matching_like = Like.where({ :photo_id => @the_photo.id, :fan_id => current_user.id })

    @the_like = matching_like.at(0)

    render({ :template => "photos/show" })
  end

  def create
    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image_url")
    the_photo.owner_id = params.fetch("query_owner_id")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image_url")
    the_photo.owner_id = params.fetch("query_owner_id")
    the_photo.comments_count = params.fetch("query_comments_count")
    the_photo.likes_count = params.fetch("query_likes_count")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end
