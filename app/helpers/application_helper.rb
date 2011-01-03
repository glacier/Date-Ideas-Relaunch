module ApplicationHelper
  # Use this function in views to dynamically set the page title
  def title(page_title)
    content_for(:title) { page_title }
  end
end
