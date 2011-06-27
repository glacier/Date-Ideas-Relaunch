require 'test_helper'

class NeighbourhoodsControllerTest < ActionController::TestCase
  setup do
    @neighbourhood = neighbourhoods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:neighbourhoods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create neighbourhood" do
    assert_difference('Neighbourhood.count') do
      post :create, :neighbourhood => @neighbourhood.attributes
    end

    assert_redirected_to neighbourhood_path(assigns(:neighbourhood))
  end

  test "should show neighbourhood" do
    get :show, :id => @neighbourhood.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @neighbourhood.to_param
    assert_response :success
  end

  test "should update neighbourhood" do
    put :update, :id => @neighbourhood.to_param, :neighbourhood => @neighbourhood.attributes
    assert_redirected_to neighbourhood_path(assigns(:neighbourhood))
  end

  test "should destroy neighbourhood" do
    assert_difference('Neighbourhood.count', -1) do
      delete :destroy, :id => @neighbourhood.to_param
    end

    assert_redirected_to neighbourhoods_path
  end
end
