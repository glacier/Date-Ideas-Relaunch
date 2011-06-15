require 'test_helper'

class DatecartsControllerTest < ActionController::TestCase
  setup do
    @user = users(:demo)
    @datecart = datecarts(:mycart)
    
    #assign demo to be an admin so that all tests have permission to run
    @r1 = roles(:admin)
    @r2 = roles(:user)
    @a1 = assignments(:a1)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:datecarts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create datecart" do
    assert_difference('Datecart.count') do
      post :create, :datecart => @datecart.attributes
    end
    assert_redirected_to datecart_path(assigns(:datecart))
  end
  
  test "should show datecart" do
    get :show, :id => @datecart.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @datecart.to_param
    assert_response :success
  end

  test "should update datecart" do
    put :update, :id => @datecart.to_param, :datecart => @datecart.attributes
    assert_redirected_to datecart_path(assigns(:datecart))
  end

  test "should destroy datecart" do
    assert_difference('Datecart.count', -1) do
      delete :destroy, :id => @datecart.to_param
    end
  end
  
  # TODO write tests for the rest of the actions for the datecarts controller
end
