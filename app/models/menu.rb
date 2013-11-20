class Menu < ActiveRecord::Base
  belongs_to :restaurant
  
  validates :name, :content_type, :data, presence: true
  validate :correct_content_type
  
  # Content type handling code based off Agile Rails text, Chapter 21
  def uploaded_menu=(menu_field)
    self.name = base_part_of(menu_field.original_filename)
    self.content_type = menu_field.content_type.chomp
    self.data = menu_field.read
  end
  
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end
  
  def correct_content_type
    valid_types = ["application/pdf"]
    unless (valid_types.include? self.content_type) || (/^image/.match self.content_type)
      errors.add(:file_type, "must be PDF or image")
    end
  end
  
end
