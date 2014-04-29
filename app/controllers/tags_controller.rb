class TagsController < ApplicationController

  include TagsHelper



  def context_tags
    respond_to do |format|
      format.html
      format.json { render json: tag_tokens(params[:q]) }
    end
  end

  def get_tags
    if params[:taggable_type] && params[:taggable_id]
     @context =  params[:taggable_type].constantize.find(params[:taggable_id].split("_")[1])
     @tags = @context.tags.map(&:attributes).to_json(:except => ["account_id","created_at","updated_at"])
     respond_to do |format|
       format.html
       format.json { render json: @tags }
     end
    end
  end

  def get_tags_filter
    #if params[:taggable_type] && params[:taggable_id]
    #  @context =  params[:taggable_type].constantize.find(params[:taggable_id])
    #  @filter_tags = @context.tags.map(&:attributes).to_json(:except => ["account_id","created_at","updated_at"])
    #  respond_to do |format|
    #    format.html
    #    format.json { render json: @filter_tags }
    #  end
    #end
    if params[:taggable_id]
      @tag_name_array = []
      @tag_name = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(params[:taggable_id])
      @tag_name.each do |tagging|
        @tag_id = tagging.tag_id
        @tag_name =  ActsAsTaggableOn::Tag.find_all_by_id(@tag_id).map {|tag|  tag.name}.join(",")
        @tag_name_array << @tag_name
      end
      respond_to do |format|
        format.json { render :json => @tag_name_array }
      end
    end
  end
end
