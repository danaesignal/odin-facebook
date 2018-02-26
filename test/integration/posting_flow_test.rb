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
end
