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
     @tag_context =  params[:taggable_type].constantize.find(params[:taggable_id].split("_")[1])
     @tags = @tag_context.tags.map(&:attributes).to_json(:except => ["account_id","created_at","updated_at"])
     respond_to do |format|
       format.html
       format.json { render json: @tags }
     end
    end
  end

  def get_tags_filter
    if params[:tagger_id]
      @tag_name_array = []
      @tag_name_find = []

      @tag_name = ActsAsTaggableOn::Tagging.find_all_by_tagger_id(params[:tagger_id])
      @tag_name.each do |tagging|
        @tag_id = tagging.tag_id
        @tag_find_name =  ActsAsTaggableOn::Tag.find_all_by_id(@tag_id).map {|tag|{:id => tag.id, :name => tag.name}}
        @tag_name_find << @tag_find_name
      end
      @tag_filter_name = @tag_name_find.uniq
        @tag_filter_name.each do |tag_filter|
          @tag_name_find_filter = tag_filter
          @tag_name_array << {:id =>@tag_name_find_filter[0][:id], :name => @tag_name_find_filter[0][:name]}
        end
      respond_to do |format|
        format.json { render :json => [@tag_name_array] }
      end
    end
  end
  def get_tag_to_bank
    if params[:tag_id]
      @tag_bank = []
      @tag_id = []
      @tag_id = params[:tag_id]
      @bank_id = ActsAsTaggableOn::Tagging.find_all_by_tag_id(params[:tag_id])
      @bank_id.each do |tagger|
        @tagger_id = tagger.tagger_id
        @taggable_id = tagger.taggable_id
        @bank = AssessmentQuestionBank.find_by_id(@tagger_id)
        @bank.tag_id = params[:tag_id]
        @tag_bank << @bank
        @tag_bank_filter = @tag_bank.uniq
      end
      respond_to do |format|
        format.json { render :json =>   @tag_bank_filter.map{ |b| b.as_json(methods: [:cached_context_short_name, :assessment_question_count]) }}
      end
    end
  end
end
