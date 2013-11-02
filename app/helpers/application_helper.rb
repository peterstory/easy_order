module ApplicationHelper
  
  # Used to set page title from within specific views
  # Thanks to http://stackoverflow.com/questions/3841323/rails-page-titles
  def append_title(page_title)
    content_for(:title) { 'Easy-Order - ' + page_title }
  end
  
  # Used to sort table columns
  # Thanks to http://railscasts.com/episodes/228-sortable-table-columns
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "sorted #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {sort: column, direction: direction}, {class: css_class}
  end
end
