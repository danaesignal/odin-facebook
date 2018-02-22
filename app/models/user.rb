class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook]

  has_many  :active_friendships, foreign_key: "initiator_id", class_name: "Friendship"
  has_many  :passive_friends, -> { where(friendships: {activated: true})},
            through: :active_friendships, source: :recipient
  has_many  :pending_requests, -> { where(friendships: {activated: false})},
            through: :active_friendships, source: :recipient

  has_many  :passive_friendships, foreign_key: "recipient_id", class_name: "Friendship"
  has_many  :active_friends, -> { where(friendships: {activated: true})},
            through: :passive_friendships, source: :initiator
  has_many  :friend_requests, -> { where(friendships: {activated: false})},
            through: :passive_friendships, source: :initiator

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
    end
  end

  def friends
    active_friends | passive_friends
  end

  def pending_friends
    pending_requests | friend_requests
  end

  def friends?(user)
    friends.include?(user)
  end

  def pending_friends?(user)
    pending_friends.include?(user)
  end

  def friendship_with(user)
    active_friendships.where(recipient_id: user.id) |
    passive_friendships.where(initiator_id: user.id)
  end
end
