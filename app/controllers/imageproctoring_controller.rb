class ImageproctoringController < ApplicationController

  before_filter :require_user
  before_filter :require_context, :except => :create_pending

  include Api::V1::Avatar
  include Api::V1::Attachment

  def create_pending
    @context = Context.find_by_asset_string(params[:context_code])
    @asset = Context.find_asset_by_asset_string(params[:attachment][:asset_string], @context) if params[:attachment][:asset_string]
    @attachment = @context.attachments.build
    @check_quota = true
    permission_object = @attachment
    permission = :create
    intent = params[:intent]

    # Using workflow_state we can keep track of the files that have been built
    # but we don't know that there's an s3 component for yet (it's still being
    # uploaded)
    workflow_state = 'unattached'
    # There are multiple reasons why we could be building a file. The default
    # is to upload it to a context.  In the other cases we need to check the
    # permission related to the purpose to make sure the file isn't being
    # uploaded just to disappear later
    if @asset.is_a?(Assignment) && intent == 'comment'
      permission_object = @asset
      permission = :attach_submission_comment_files
      @context = @asset
      @check_quota = false
    elsif @asset.is_a?(Assignment) && intent == 'submit'
      permission_object = @asset
      permission = (@asset.submission_types || "").match(/online_upload/) ? :submit : :nothing
      @group = @asset.group_category.group_for(@current_user) if @asset.has_group_category?
      @context = @group || @current_user
      @check_quota = false
      @attachment.submission_attachment = true
    elsif @context && intent == 'attach_discussion_file'
      permission_object = @context.discussion_topics.scoped.new
      permission = :attach
    elsif @context && intent == 'message'
      permission_object = @context
      permission = :send_messages
      @check_quota = false
    elsif @context && intent && intent != 'upload'
      # In other cases (like unzipping a file, extracting a QTI, etc.
      # we don't actually want the uploaded file to show up in the context's
      # file listings.  If you set its workflow_state to unattached_temporary
      # then it will never be activated.
      workflow_state = 'unattached_temporary'
      @check_quota = false
    end

    @attachment.context = @context
    @attachment.user = @current_user
    #if authorized_action(permission_object, @current_user, permission)
    if @context.respond_to?(:is_a_context?) && @check_quota
      get_quota
      return if quota_exceeded(named_context_url(@context, :context_files_url))
    end
    @attachment.filename = params[:attachment][:filename]
    @attachment.file_state = 'deleted'
    @attachment.workflow_state = workflow_state
    if @context.respond_to?(:folders)
      if params[:attachment][:folder_id].present?
        @folder = @context.folders.active.find_by_id(params[:attachment][:folder_id])
      end
      @folder ||= Folder.unfiled_folder(@context)
      @attachment.folder_id = @folder.id
    end
    @attachment.content_type = Attachment.mimetype(@attachment.filename)
    @attachment.save!

    res = @attachment.ajax_upload_params(@current_pseudonym,
                                         named_context_url(@context, :context_files_url, :format => :text, :duplicate_handling => params[:attachment][:duplicate_handling]),
                                         s3_success_url(@attachment.id, :uuid => @attachment.uuid, :duplicate_handling => params[:attachment][:duplicate_handling]),
                                         :no_redirect => params[:no_redirect],
                                         :upload_params => {
                                             'attachment[folder_id]' => params[:attachment][:folder_id] || '',
                                             'attachment[unattached_attachment_id]' => @attachment.id,
                                             'check_quota_after' => @check_quota ? '1' : '0'
                                         },
                                         :ssl => request.ssl?)
    #render :json => res
    #end
    #end


    if (folder_id = params[:attachment].delete(:folder_id)) && folder_id.present?
      @folder = @context.folders.active.find_by_id(folder_id)
    end
    @folder ||= Folder.unfiled_folder(@context)
    params[:attachment][:uploaded_data] ||= params[:attachment_uploaded_data]
    params[:attachment][:uploaded_data] ||= params[:file]
    params[:attachment][:user] = @current_user
    params[:attachment].delete :context_id
    params[:attachment].delete :context_type
    duplicate_handling = params.delete :duplicate_handling
    if (unattached_attachment_id = params[:attachment].delete(:unattached_attachment_id)) && unattached_attachment_id.present?
      @attachment = @context.attachments.find_by_id_and_workflow_state(unattached_attachment_id, 'unattached')
    end
    @attachment ||= @context.attachments.build
    #if authorized_action(@attachment, @current_user, :create)
    get_quota
    return if (params[:check_quota_after].nil? || params[:check_quota_after] == '1') &&
        quota_exceeded(named_context_url(@context, :context_files_url))
    #if authorized_action(@context, :context_files_url, :update_avatar)
    #  render :json => avatar_image_url_json_for_user(@context)
    #end



    respond_to do |format|
      @attachment.folder_id ||= @folder.id
      @attachment.workflow_state = nil
      @attachment.file_state = 'available'
      success = nil
      if params[:attachment] && params[:attachment][:source_attachment_id]
        a = Attachment.find(params[:attachment].delete(:source_attachment_id))
        if a.root_attachment_id && att = @folder.attachments.find_by_id(a.root_attachment_id)
          @attachment = att
          success = true
        elsif a.grants_right?(@current_user, session, :download)
          @attachment = a.clone_for(@context, @attachment)
          success = @attachment.save
        end
      end
      if params[:attachment][:uploaded_data]
        success = @attachment.update_attributes(params[:attachment])
        @attachment.errors.add(:base, t('errors.server_error', "Upload failed, server error, please try again.")) unless success
      else
        @attachment.errors.add(:base, t('errors.missing_field', "Upload failed, expected form field missing"))
      end
      deleted_attachments = @attachment.handle_duplicates(duplicate_handling)
      unless @attachment.downloadable?
        success = false
        if (params[:attachment][:uploaded_data].size == 0 rescue false)
          @attachment.errors.add(:base, t('errors.empty_file', "That file is empty.  Please upload a different file."))
        else
          @attachment.errors.add(:base, t('errors.upload_failed', "Upload failed, please try again."))
        end
        unless @attachment.new_record?
          @attachment.destroy rescue @attachment.delete
        end
      end
      @context.avatar_image_url =  file_download_url(@attachment, { :verifier => @attachment.uuid, :download => '1', :download_frd => '1' }) unless @attachment.nil?
      @context.avatar_image_source = "attachment"
      @context.save!

      if success
        @attachment.move_to_bottom
        format.html { return_to(params[:return_to], named_context_url(@context, :context_files_url)) }
        format.json do
          render_attachment_json(@attachment, deleted_attachments, @folder)
        end
        format.text do
          render_attachment_json(@attachment, deleted_attachments, @folder)
        end
      else
        format.html { render :action => "new" }
        format.json { render :json => @attachment.errors }
        format.text { render :json => @attachment.errors }
      end

    end

  end

  def image_proctoring

    #def create_pending
      @context = Context.find_by_asset_string(params[:context_code])
      @asset = Context.find_asset_by_asset_string(params[:attachment][:asset_string], @context) if params[:attachment][:asset_string]
      @attachment = @context.attachments.build
      @check_quota = true
      permission_object = @attachment
      permission = :create
      intent = params[:attachment][:intent]

      # Using workflow_state we can keep track of the files that have been built
      # but we don't know that there's an s3 component for yet (it's still being
      # uploaded)
      workflow_state = 'unattached'
      # There are multiple reasons why we could be building a file. The default
      # is to upload it to a context.  In the other cases we need to check the
      # permission related to the purpose to make sure the file isn't being
      # uploaded just to disappear later
      if @asset.is_a?(Assignment) && intent == 'comment'
        permission_object = @asset
        permission = :attach_submission_comment_files
        @context = @asset
        @check_quota = false
      elsif @asset.is_a?(Assignment) && intent == 'submit'
        permission_object = @asset
        permission = (@asset.submission_types || "").match(/online_upload/) ? :submit : :nothing
        @group = @asset.group_category.group_for(@current_user) if @asset.has_group_category?
        @context = @group || @current_user
        @check_quota = false
        @attachment.submission_attachment = true
      elsif @context && intent == 'attach_discussion_file'
        permission_object = @context.discussion_topics.scoped.new
        permission = :attach
      elsif @context && intent == 'message'
        permission_object = @context
        permission = :send_messages
        @check_quota = false
      elsif @context && intent && intent != 'upload'
        # In other cases (like unzipping a file, extracting a QTI, etc.
        # we don't actually want the uploaded file to show up in the context's
        # file listings.  If you set its workflow_state to unattached_temporary
        # then it will never be activated.
        workflow_state = 'unattached_temporary'
        @check_quota = false
      end

      @attachment.context = @context
      @attachment.user = @current_user
      #if authorized_action(permission_object, @current_user, permission)
        if @context.respond_to?(:is_a_context?) && @check_quota
          get_quota
          return if quota_exceeded(named_context_url(@context, :context_files_url))
        end
        @attachment.filename = params[:attachment][:filename]
        @attachment.file_state = 'deleted'
        @attachment.workflow_state = workflow_state
        if @context.respond_to?(:folders)
          if params[:attachment][:folder_id].present?
            @folder = @context.folders.active.find_by_id(params[:attachment][:folder_id])
          end
          @folder ||= Folder.unfiled_folder(@context)
          @attachment.folder_id = @folder.id
        end
        @attachment.content_type = Attachment.mimetype(@attachment.filename)
        @attachment.save!

        res = @attachment.ajax_upload_params(@current_pseudonym,
                                             named_context_url(@context, :context_files_url, :format => :text, :duplicate_handling => params[:attachment][:duplicate_handling]),
                                             s3_success_url(@attachment.id, :uuid => @attachment.uuid, :duplicate_handling => params[:attachment][:duplicate_handling]),
                                             :no_redirect => params[:no_redirect],
                                             :upload_params => {
                                                 'attachment[folder_id]' => params[:attachment][:folder_id] || '',
                                                 'attachment[unattached_attachment_id]' => @attachment.id,
                                                 'check_quota_after' => @check_quota ? '1' : '0'
                                             },
                                             :ssl => request.ssl?)
        #render :json => res
      #end
    #end


      if (folder_id = params[:attachment].delete(:folder_id)) && folder_id.present?
        @folder = @context.folders.active.find_by_id(folder_id)
      end
      @folder ||= Folder.unfiled_folder(@context)
      params[:attachment][:uploaded_data] ||= params[:attachment_uploaded_data]
      params[:attachment][:uploaded_data] ||= params[:file]
      params[:attachment][:user] = @current_user
      params[:attachment].delete :context_id
      params[:attachment].delete :context_type
      duplicate_handling = params.delete :duplicate_handling
      if (unattached_attachment_id = params[:attachment].delete(:unattached_attachment_id)) && unattached_attachment_id.present?
        @attachment = @context.attachments.find_by_id_and_workflow_state(unattached_attachment_id, 'unattached')
      end
      @attachment ||= @context.attachments.build
      #if authorized_action(@attachment, @current_user, :create)
        get_quota
        return if (params[:check_quota_after].nil? || params[:check_quota_after] == '1') &&
            quota_exceeded(named_context_url(@context, :context_files_url))

        respond_to do |format|
          @attachment.folder_id ||= @folder.id
          @attachment.workflow_state = nil
          @attachment.file_state = 'available'
          success = nil
          if params[:attachment] && params[:attachment][:source_attachment_id]
            a = Attachment.find(params[:attachment].delete(:source_attachment_id))
            if a.root_attachment_id && att = @folder.attachments.find_by_id(a.root_attachment_id)
              @attachment = att
              success = true
            elsif a.grants_right?(@current_user, session, :download)
              @attachment = a.clone_for(@context, @attachment)
              success = @attachment.save
            end
          end
          if params[:attachment][:uploaded_data]
            success = @attachment.update_attributes(params[:attachment])
            @attachment.errors.add(:base, t('errors.server_error', "Upload failed, server error, please try again.")) unless success
          else
            @attachment.errors.add(:base, t('errors.missing_field', "Upload failed, expected form field missing"))
          end
          deleted_attachments = @attachment.handle_duplicates(duplicate_handling)
          unless @attachment.downloadable?
            success = false
            if (params[:attachment][:uploaded_data].size == 0 rescue false)
              @attachment.errors.add(:base, t('errors.empty_file', "That file is empty.  Please upload a different file."))
            else
              @attachment.errors.add(:base, t('errors.upload_failed', "Upload failed, please try again."))
            end
            unless @attachment.new_record?
              @attachment.destroy rescue @attachment.delete
            end
          end
          if success
            @attachment.move_to_bottom
            format.html { return_to(params[:return_to], named_context_url(@context, :context_files_url)) }
            format.json do
              render_attachment_json(@attachment, deleted_attachments, @folder)
            end
            format.text do
              render_attachment_json(@attachment, deleted_attachments, @folder)
            end
          else
            format.html { render :action => "new" }
            format.json { render :json => @attachment.errors }
            format.text { render :json => @attachment.errors }
          end
          Imageproctoring.create!(attachment_id: @attachment.id, user_id: @current_user.id, quiz_id: params[:quiz_id])
        end
      #end

  end
  private

  def render_attachment_json(attachment, deleted_attachments, folder = attachment.folder)
    json = {
        :attachment => attachment.as_json(
            allow: :uuid,
            methods: [:uuid,:readable_size,:mime_class,:currently_locked,:scribdable?,:thumbnail_url],
            permissions: {user: @current_user, session: session},
            include_root: false
        ),
        :deleted_attachment_ids => deleted_attachments.map(&:id)
    }
    #if folder.name == 'profile pictures'
    #  json[:avatar] = avatar_json(@current_user, attachment, { :type => 'attachment' })
    #end

    render :json => json, :as_text => true
  end

end

