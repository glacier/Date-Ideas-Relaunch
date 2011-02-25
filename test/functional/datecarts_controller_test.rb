require 'test_helper'

class DatecartsControllerTest < ActionController::TestCase
  setup do
    @datecart = datecarts(:one)
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

    assert_redirected_to datecarts_path
  end
end
