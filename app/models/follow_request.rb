# == Schema Information
#
# Table name: follow_requests
#
#  id           :bigint           not null, primary key
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#  sender_id    :integer
#
class FollowRequest < ApplicationRecord
  # Direct associations
  belongs_to :follower, required: true, class_name: "User", foreign_key: "sender_id"
  belongs_to :followed, required: true, class_name: "User", foreign_key: "recipient_id"
end
