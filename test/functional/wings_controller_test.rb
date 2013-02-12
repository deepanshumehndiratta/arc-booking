require 'test_helper'

class WingsControllerTest < ActionController::TestCase
  setup do
    @wing = wings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wing" do
    assert_difference('Wing.count') do
      post :create, wing: { description: @wing.description, image: @wing.image, name: @wing.name }
    end

    assert_redirected_to wing_path(assigns(:wing))
  end

  test "should show wing" do
    get :show, id: @wing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wing
    assert_response :success
  end

  test "should update wing" do
    put :update, id: @wing, wing: { description: @wing.description, image: @wing.image, name: @wing.name }
    assert_redirected_to wing_path(assigns(:wing))
  end

  test "should destroy wing" do
    assert_difference('Wing.count', -1) do
      delete :destroy, id: @wing
    end

    assert_redirected_to wings_path
  end
end
