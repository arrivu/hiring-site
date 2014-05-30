class ImageproctoringController < ApplicationController

  #before_filter :require_user

  include Api::V1::Attachment

  def image_proctoring
    image = params[:image]
    File.write("#{Rails.root}/public/uploads/#{image}.png", 'wb') do |f|
      f.write(Base64.decode64(image))
    end
  end
end
