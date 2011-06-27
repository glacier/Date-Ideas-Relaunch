require 'test_helper'

class CartItemsControllerTest < ActionController::TestCase
  setup do
    @cart_item = cart_items(:one)
  end

  test "route" do
    assert_routing '/datecarts/980190962/cart_items/new', { :controller => "cart_items", :action => "new", :datecart_id => "980190962"}
  end
  
  # TODO: Figure out how do to functional tests with nested routes
  # test "should get index" do
  #    get :index
  #    assert_response :success
  #    assert_not_nil assigns(:cart_items)
  #  end
  #  
  #  test "should get new" do
  #    get :new, :datecart_id => "1"
  #    assert_response :success
  #  end
  # 
  #  test "should create cart_item" do
  #      assert_difference('CartItem.count') do
  #        post :create, :datecart_id => 1, :cart_item => @cart_item.attributes
  #      end
  #    
  #      assert_redirected_to datecart_cart_item_path(assigns(:cart_item))
  #    end
  #    
  #    test "should show cart_item" do
  #      get :show, :id => @cart_item.to_param
  #      assert_response :success
  #    end
  #    
  #    test "should get edit" do
  #      get :edit, :id => @cart_item.to_param
  #      assert_response :success
  #    end
  #    
  #    test "should update cart_item" do
  #      put :update, :id => @cart_item.to_param, :cart_item => @cart_item.attributes
  #      assert_redirected_to datecart_cart_item_path(assigns(:cart_item))
  #    end
  #    
  #    test "should destroy cart_item" do
  #      assert_difference('CartItem.count', -1) do
  #        delete :destroy, :id => @cart_item.to_param
  #      end
  #    
  #      assert_redirected_to datecart_cart_items_path
  #    end
end
