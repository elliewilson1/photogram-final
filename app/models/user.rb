# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :string
#  avatar_url             :string
#  bio                    :text
#  comments_count         :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer
#  name                   :string
#  private                :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  website                :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Direct associations
  has_many  :photos, class_name: "Photo", foreign_key: "owner_id", dependent: :destroy
  has_many  :likes, class_name: "Like", foreign_key: "fan_id", dependent: :destroy
  has_many  :comments, class_name: "Comment", foreign_key: "author_id", dependent: :destroy
  has_many  :followings, class_name: "FollowRequest", foreign_key: "sender_id", dependent: :destroy
  has_many  :followers, class_name: "FollowRequest", foreign_key: "recipient_id", dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
