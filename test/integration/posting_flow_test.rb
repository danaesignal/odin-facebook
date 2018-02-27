require 'test_helper'

class PostingFlowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "new posts should show up on post timeline" do
    sign_in @user
    get posts_path

    assert_no_match "Test", response.body

    author_id = @user.id
    content = "Test"

    post posts_path, params: {post:{author_id: author_id, content: content}}

    get posts_path
    assert_match "Test", response.body
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
    get posts_path

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
end
