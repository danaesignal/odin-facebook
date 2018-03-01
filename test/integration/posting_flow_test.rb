require 'test_helper'

class PostingFlowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "new posts from self and friends should show up on post timeline" do
    sign_in @user
    get posts_path

    assert_no_match "Test", response.body

    author_id = @user.id
    content = "Test"

    post posts_path, params: {post:{author_id: author_id, content: content}}

    get posts_path
    assert_match "Test", response.body

    post friendships_path, params: {friendship:{recipient_id:@other_user.id}}
    
    sign_in @other_user
    friendship = Friendship.where(initiator_id: @user.id).first
    patch friendship_path(friendship), params: {friendship: {activated:true}}

    author_id = @other_user.id
    content = "Task"

    post posts_path, params: {post:{author_id: author_id, content: content}}
    get posts_path

    assert_match "Test", response.body
    assert_match "Task", response.body
  end

  test "user's posts should be visible on user's page" do
    sign_in @user
    get user_path @user

    assert_no_match "Test", response.body

    author_id = @user.id
    content = "Test"

    post posts_path, params: {post:{author_id: author_id, content: content}}

    get user_path @user
    assert_match "Test", response.body

    sign_in @other_user
    get user_path @user
    assert_match "Test", response.body

    get user_path @other_user
    assert_no_match "Test", response.body
  end

  test "users should be able to comment on posts" do
    sign_in @user

    author_id = @user.id
    content = "Test"

    post posts_path, params: {post:{author_id: author_id, content: content}}

    get posts_path
    assert_match "0 comments", response.body

    comment_author = @other_user.id
    commented_post = @user.posts.first.id
    comment_content = "Here we go."

    post comments_path, params: { comment: { author_id: comment_author, post_id:
                                  commented_post, content: comment_content } }

    get post_path(@user.posts.first)
    assert_match "1 comment", response.body
  end

  test "users should be able to like and unlike content" do
    sign_in @user

    author_id = @user.id
    content = "Test"

    post posts_path, params: {post:{author_id: author_id, content: content}}
    content_id = @user.posts.first.id

    get posts_path
    assert_match "0 likes", response.body

    post likes_path, params: {author_id: author_id, content_id: content_id,
                             content_type: "post"}

    get posts_path
    assert_match "1 like", response.body

    delete like_path(@user.posts.first.likes.first)

    get posts_path
    assert_match "0 likes", response.body
  end
end
