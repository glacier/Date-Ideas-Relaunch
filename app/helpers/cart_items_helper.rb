module CartItemsHelper
  def show_name(cart_item)
    if cart_item.business.nil?
      cart_item.event.title
    else
      cart_item.business.name
    end
  end
end
