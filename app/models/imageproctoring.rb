class Imageproctoring < ActiveRecord::Base

  attr_accessible :quiz_id,:user_id,:proctoring_image_attachment_id, :imageData
  #belongs_to :user
  #belongs_to :quiz

  def self.save(upload)
    name =  upload[:imageData]
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload[:imageData].read) }
  end
end
