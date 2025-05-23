class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show" })
  end

  def create
    recipient_id = params.fetch("query_recipient_id")
    matching_user = User.where({ :id => recipient_id }).at(0)

    the_follow_request = FollowRequest.new
    the_follow_request.sender_id = current_user.id
    the_follow_request.recipient_id = recipient_id

    if matching_user.private?
      the_follow_request.status = "pending"
    else
      the_follow_request.status = "accepted"
    end

    the_follow_request.save

    if the_follow_request.status == "accepted"
      return redirect_to("/users/" + matching_user.username)
    else
      return redirect_to("/", { :notice => "Follow request created successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/follow_requests/#{the_follow_request.id}", { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/follow_requests/#{the_follow_request.id}", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)
    the_follow_request.destroy

    return redirect_to("/users", { :notice => "Follow request deleted successfully." })
  end
end
