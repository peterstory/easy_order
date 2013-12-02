module ApplicationHelper
  
  # Used to set page title from within specific views
  # Thanks to http://stackoverflow.com/questions/3841323/rails-page-titles
  def append_title(page_title)
    content_for(:title) { 'Easy-Order - ' + page_title }
  end
  
  # Used to set a class for the <section> tag in which each pages's unique 
  # content resides. Useful for page specific styling.
  def append_section_class(section_class)
    content_for(:section_class) { section_class }
  end
  
  
  # Used to sort table columns
  # Thanks to http://railscasts.com/episodes/228-sortable-table-columns
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "sorted #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    unless (defined? only_for_user)
      link_to title, {sort: column, direction: direction}, {class: css_class}
    else  # Include an additional parameter in the URL
      link_to title, {sort: column, direction: direction, user_id: only_for_user}, {class: css_class}
    end
  end

end
