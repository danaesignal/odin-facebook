require 'test_helper'

class FriendingFlowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "should allow you to send friend requests" do
    sign_in @user
    get user_path(@other_user)

    assert_match "Send Friend Request", response.body
    post friendships_path, params: {friendship:{recipient_id:@other_user.id}}

    get user_path(@other_user)
    assert_no_match "Send Friend Request", response.body
  end

  test "should allow you to rescind friend requests" do
    sign_in @user
    get user_path(@other_user)

    assert_match "Send Friend Request", response.body
    post friendships_path, params: {friendship:{recipient_id:@other_user.id}}

    get user_path(@other_user)
    assert_no_match "Send Friend Request", response.body

    friendship = Friendship.where(recipient_id: @other_user.id).first
    delete friendship_path(friendship), params: {friendship: {activated:true}}

    get user_path(@other_user)
    assert_match "Send Friend Request", response.body
  end

  test "should allow you to accept friend requests" do
    sign_in @user
    get user_path(@other_user)

    post friendships_path, params: {friendship:{recipient_id:@other_user.id}}

    sign_in @other_user
    get friendships_path
    assert_match "1 friend request", response.body

    friendship = Friendship.where(initiator_id: @user.id).first

    patch friendship_path(friendship), params: {friendship: {activated:true}}
    get friendships_path

    assert_no_match "1 friend request", response.body
    assert_match "David Williams", response.body
  end

  test "should allow you to deny friend requests" do
    sign_in @user
    get user_path(@other_user)

    post friendships_path, params: {friendship:{recipient_id:@other_user.id}}

    sign_in @other_user
    get friendships_path
    assert_match "1 friend request", response.body

    friendship = Friendship.where(initiator_id: @user.id).first

    delete friendship_path(friendship), params: {friendship: {activated:true}}
    get friendships_path

    assert_no_match "1 friend request", response.body
    assert_no_match "David Williams", response.body
  end
end
