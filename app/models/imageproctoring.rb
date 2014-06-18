class Imageproctoring < ActiveRecord::Base
  belongs_to :user
  #belongs_to :attachment
  #has_one :thumbnail, :foreign_key => "parent_id", :conditions => {:thumbnail => "thumb"}
  #has_many :thumbnails, :foreign_key => "parent_id"
  #attr_accessible :quiz_id,:user_id,:proctoring_image_attachment_id, :imageData
  #belongs_to :user
  #belongs_to :quiz

  #def self.save(upload)
  #  name =  upload[:imageData]
  #  directory = "public/data"
  #  # create the file path
  #  path = File.join(directory, name)
  #  # write the file
  #  File.open(path, "wb") { |f| f.write(upload[:imageData].read) }
  #end
  #attr_accessor :file_data
  #def before_create
  #  input = self.file_data
  #  @binary = Binary.create(:file_data => input)
  #  self.binary_id = @binary.id
  #  self.filename = input.original_filename
  #  self.content_type = input.content_type.chomp
  #  self.size = @binary.data.size
  #end
end
