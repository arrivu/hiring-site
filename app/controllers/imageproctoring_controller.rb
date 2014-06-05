class ImageproctoringController < ApplicationController

  before_filter :require_user

  include Api::V1::Attachment
  def self.save(upload)
    name =  upload[:imageData]
    directory = "public/uploads"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload[:imageData].read) }
  end
  def image_proctoring
    #@proctoring_image = params[:imageData]
    #File.write("#{Rails.root}/public/uploads/#{image}.png", 'wb') do |f|
    #  f.write(Base64.decode64(image))
    #end
    #if params[:imageData].try(:original_filename) == 'blob'
    #  params[:imageData].original_filename << '.png'
    #end
    data = params[:imageData]
    Imageproctoring.create!(imageData: data)
    #@folder ||= Folder.unfiled_folder(@proctoring_image)
    #params[:attachment][:uploaded_data] ||= params[:attachment_uploaded_data]
    #params[:attachment][:uploaded_data] ||= params[:file]
    #params[:attachment][:user] = @current_user
    #params[:attachment].delete :context_id
    #params[:attachment].delete :context_type
    #duplicate_handling = params.delete :duplicate_handling
    #@attachment ||= @context.attachments.build
    #
    #respond_to do |format|
    #  @attachment.folder_id ||= @folder.id
    #  @attachment.workflow_state = nil
    #  @attachment.file_state = 'available'
    # # success = nil
    #  if params[:attachment][:uploaded_data]
    #    success = @attachment.update_attributes(params[:attachment])
    #    @attachment.errors.add(:base, t('errors.server_error', "Upload failed, server error, please try again.")) unless success
    #  else
    #    @attachment.errors.add(:base, t('errors.missing_field', "Upload failed, expected form field missing"))
    #  end
    #end

  end
end
