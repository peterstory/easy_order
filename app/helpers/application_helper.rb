module ApplicationHelper
  
  # Used to set page title from within specific views
  # Thanks to http://stackoverflow.com/questions/3841323/rails-page-titles
  def append_title(page_title)
    content_for(:title) { 'Easy-Order - ' + page_title }
  end
end
