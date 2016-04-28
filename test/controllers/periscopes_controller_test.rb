require 'test_helper'

class PeriscopesControllerTest < ActionController::TestCase
  setup do
    @periscope = periscopes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:periscopes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create periscope" do
    assert_difference('Periscope.count') do
      post :create, periscope: { broadcast_id: @periscope.broadcast_id, twitterhandle: @periscope.twitterhandle }
    end

    assert_redirected_to periscope_path(assigns(:periscope))
  end

  test "should show periscope" do
    get :show, id: @periscope
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @periscope
    assert_response :success
  end

  test "should update periscope" do
    patch :update, id: @periscope, periscope: { broadcast_id: @periscope.broadcast_id, twitterhandle: @periscope.twitterhandle }
    assert_redirected_to periscope_path(assigns(:periscope))
  end

  test "should destroy periscope" do
    assert_difference('Periscope.count', -1) do
      delete :destroy, id: @periscope
    end

    assert_redirected_to periscopes_path
  end
end
