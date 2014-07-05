#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

module SIS
  class AssessmentQuestionImporter < BaseImporter
    def process
      start = Time.now
      importer = Work.new(@batch_id, @root_account, @logger)

      if SisBatch.find_by_id(@batch_id).batch_mode == true
        AssessmentQuestionBank.all.each do |bank_status|
          bank_status.workflow_state ="deleted"
          bank_status.save!
        end
        AssessmentQuestion.all.each do |question_status|
          question_status.workflow_state ="deleted"
          question_status.save!
        end
      end

        yield importer

      @logger.debug("AssessmentQuestion took #{Time.now - start} seconds")
      return importer.success_count
    end

    private
    class Work
      include TagsHelper
      include ApplicationHelper
      attr_accessor :success_count, :question, :bank, :assessment_question, :id, :weight_count, :question_row

      def initialize(batch_id, root_account, logger)
        @batch_id = batch_id
        @root_account = root_account
        @logger = logger
        @question = {}
        @bank = {}
        @success_count = 0
        @weight_count = 0
        @question_row = 0
      end

      def unique_local_id
          id = rand(10000)
      end

      def add_assessment_question( question_bank_title,question_data,regrade_option,points_possible,question_tag,
                                   correct_comments,incorrect_comments,neutral_comments,question_type,name,question_name,
                                   question_text,status,answers,ans1_id,ans1_comments,ans1_text,ans1_weight,ans2_id,ans2_comments,ans2_text,
                                   ans2_weight,ans3_id,ans3_comments,ans3_text,ans3_weight,ans4_id,ans4_comments,ans4_text,
                                   ans4_weight,ans5_id,ans5_comments,ans5_text,ans5_weight,text_after_answers,
                                   assessment_question_id)
        raise ImportError, "No question_bank_title given for a question_bank" unless question_bank_title.present?

        @logger.debug("Processing Group #{[question_bank_title,question_data,regrade_option,points_possible,question_tag,
                                           correct_comments,incorrect_comments,neutral_comments,question_type,name,
                                           question_name,question_text,status,answers,ans1_id,ans1_comments,ans1_text,ans1_weight,
                                           ans2_id,ans2_comments,ans2_text,ans2_weight,ans3_id,ans3_comments,ans3_text,ans3_weight,
                                           ans4_id,ans4_comments,ans4_text,ans4_weight,ans5_id,ans5_comments,ans5_text,ans5_weight,
                                           text_after_answers,assessment_question_id].inspect}")

        ans1_id = unique_local_id
        ans2_id = unique_local_id
        ans3_id = unique_local_id
        ans4_id = unique_local_id
        ans5_id = unique_local_id

        if question_bank_title.present?
          if AssessmentQuestionBank.active.find_by_title(question_bank_title).present?
            question_bank_id = AssessmentQuestionBank.active.find_by_title(question_bank_title).id
            @bank = @root_account.assessment_question_banks.active.find(question_bank_id)
                @question_row += 1
                question = @bank.assessment_questions.new
                @assessment_question ||= {}
                if question_type == "true_false_question"
                  if ans1_text !=nil && ans1_weight != nil and ans2_text !=nil && ans2_weight != nil
                    question.question_data = {:regrade_option => regrade_option,:points_possible => points_possible,
                                              :correct_comments => correct_comments,
                                              :incorrect_comments => incorrect_comments, :neutral_comments => neutral_comments,
                                              :question_type => question_type,:name => name, :question_name => question_name,
                                              :question_text => question_text,:answers => [ {:id => ans1_id,:comments => ans1_comments,
                                              :text => ans1_text,:weight => ans1_weight.to_i},  {:id => ans2_id,:comments => ans2_comments,
                                              :text => ans2_text,:weight => ans2_weight.to_i} ],:text_after_answers => text_after_answers,
                                              :assessment_question_id => assessment_question_id }
                    if ans1_weight == "100" || ans1_weight == "0" and ans2_weight == "100" || ans2_weight == "0"
                      if ans1_weight != ans2_weight
                        if question.with_versioning(&:save)
                          question.workflow_state = status
                          #question.insert_at_bottom
                        end
                      else
                        raise ImportError, "Improper weight for question #{question_row}"
                      end
                    else
                      raise ImportError, "Improper weight for question #{question_row}"
                    end
                  else
                    raise ImportError, "Improper answer for question #{question_row}"
                  end
                elsif question_type == "multiple_choice_question"
                  if ans1_text !=nil && ans1_weight != nil and ans2_text !=nil && ans2_weight != nil
                       question.question_data = {:regrade_option => regrade_option,:points_possible => points_possible,
                                                 :correct_comments => correct_comments,
                                                 :incorrect_comments => incorrect_comments, :neutral_comments => neutral_comments,
                                                 :question_type => question_type,:name => name, :question_name => question_name,
                                                 :question_text => question_text,:answers => [ {:id => ans1_id,:comments => ans1_comments,
                                                 :text => ans1_text,:weight => ans1_weight.to_i}, {:id => ans2_id,:comments => ans2_comments,
                                                 :text => ans2_text,:weight => ans2_weight.to_i} ],:text_after_answers => text_after_answers,
                                                 :assessment_question_id => assessment_question_id }

                       if ans3_text !=nil && ans3_weight !=nil
                         question.question_data[:answers] << {:id => ans3_id,:comments => ans3_comments,
                                                              :text => ans3_text,:weight => ans3_weight.to_i}
                       end
                       if ans4_text !=nil && ans4_weight !=nil
                       question.question_data[:answers] << {:id => ans4_id,:comments => ans4_comments,
                                                              :text => ans4_text,:weight => ans4_weight.to_i}
                       end

                       if ans5_text !=nil && ans5_weight != nil
                         question.question_data[:answers] << {:id => ans5_id,:comments => ans5_comments,
                                                              :text => ans5_text,:weight => ans5_weight.to_i}
                       end
                       @weight_count = 0
                       if ans1_weight == "100" || ans1_weight == "0" || ans1_weight == nil and ans2_weight == "100" ||
                          ans2_weight == "0" || ans2_weight == nil and ans3_weight == "100" || ans3_weight == "0" ||
                          ans3_weight == nil and ans4_weight == "100" || ans4_weight == "0" || ans4_weight == nil and
                          ans5_weight == "100" || ans5_weight == "0" || ans5_weight == nil
                         if ans1_weight == "100"
                           @weight_count +=1
                         end
                         if ans2_weight == "100"
                           @weight_count +=1
                         end
                         if ans3_weight == "100"
                           @weight_count +=1
                         end
                         if ans4_weight == "100"
                           @weight_count +=1
                         end
                         if ans5_weight == "100"
                           @weight_count +=1
                         end
                         if @weight_count == 1
                           if question.with_versioning(&:save)
                             question.workflow_state = status
                             #question.insert_at_bottom
                           end
                         else
                           raise ImportError, "Improper weight for question #{question_row}"
                         end
                       else
                         raise ImportError, "Improper weight for question #{question_row}"
                       end
                  else
                    raise ImportError, "Improper answer for question #{question_row}"
                  end
                elsif question_type == "short_answer_question"
                    if ans1_text !=nil && ans1_weight != nil and ans2_text !=nil && ans2_weight != nil
                        question.question_data = {:regrade_option => regrade_option,:points_possible => points_possible,
                                                  :correct_comments => correct_comments,
                                                  :incorrect_comments => incorrect_comments, :neutral_comments => neutral_comments,
                                                  :question_type => question_type,:name => name, :question_name => question_name,
                                                  :question_text => question_text,:answers => [ {:id => ans1_id,:comments => ans1_comments,
                                                  :text => ans1_text,:weight => ans1_weight.to_i}, {:id => ans2_id,:comments => ans2_comments,
                                                  :text => ans2_text,:weight => ans2_weight.to_i}],:text_after_answers => text_after_answers,
                                                  :assessment_question_id => assessment_question_id }

                        if ans3_text !=nil && ans3_weight !=nil
                          question.question_data[:answers] << {:id => ans3_id,:comments => ans3_comments,
                                                               :text => ans3_text,:weight => ans3_weight.to_i}
                        end
                        if ans4_text !=nil && ans4_weight !=nil
                          question.question_data[:answers] << {:id => ans4_id,:comments => ans4_comments,
                                                               :text => ans4_text,:weight => ans4_weight.to_i}
                        end

                        if ans5_text !=nil && ans5_weight != nil
                          question.question_data[:answers] << {:id => ans5_id,:comments => ans5_comments,
                                                               :text => ans5_text,:weight => ans5_weight.to_i}
                        end
                          if ans1_weight == "100" ||  ans1_weight == nil and ans2_weight == "100" ||
                             ans2_weight == nil and ans3_weight == "100" || ans3_weight == nil and
                             ans4_weight == "100" || ans4_weight == nil and ans5_weight == "100" || ans5_weight == nil
                            if question.with_versioning(&:save)
                              question.workflow_state = status
                              #question.insert_at_bottom
                            end
                          else
                            raise ImportError, "Improper weight for question #{question_row}"
                          end
                    else
                      raise ImportError, "Improper answer for question #{question_row}"
                    end
                elsif question_type == "multiple_answers_question"
                  if ans1_text !=nil && ans1_weight != nil and ans2_text !=nil && ans2_weight != nil
                      question.question_data = {:regrade_option => regrade_option,:points_possible => points_possible,
                                                :correct_comments => correct_comments,
                                                :incorrect_comments => incorrect_comments, :neutral_comments => neutral_comments,
                                                :question_type => question_type,:name => name, :question_name => question_name,
                                                :question_text => question_text,:answers => [ {:id => ans1_id,:comments => ans1_comments,
                                                :text => ans1_text,:weight => ans1_weight.to_i}, {:id => ans2_id,:comments => ans2_comments,
                                                :text => ans2_text,:weight => ans2_weight.to_i}],:text_after_answers => text_after_answers,
                                                :assessment_question_id => assessment_question_id }
                      if ans3_text !=nil && ans3_weight !=nil
                        question.question_data[:answers] << {:id => ans3_id,:comments => ans3_comments,
                                                             :text => ans3_text,:weight => ans3_weight.to_i}
                      end
                      if ans4_text !=nil && ans4_weight !=nil
                        question.question_data[:answers] << {:id => ans4_id,:comments => ans4_comments,
                                                             :text => ans4_text,:weight => ans4_weight.to_i}
                      end
                      if ans5_text !=nil && ans5_weight != nil
                        question.question_data[:answers] << {:id => ans5_id,:comments => ans5_comments,
                                                             :text => ans5_text,:weight => ans5_weight.to_i}
                      end
                      if ans1_weight == "100" || ans1_weight == "0" || ans1_weight == nil and ans2_weight == "100" ||
                         ans2_weight == "0" || ans2_weight == nil and ans3_weight == "100" || ans3_weight == "0" ||
                         ans3_weight == nil and ans4_weight == "100" || ans4_weight == "0" || ans4_weight == nil and
                         ans5_weight == "100" || ans5_weight == "0" || ans5_weight == nil
                        if question.with_versioning(&:save)
                          question.workflow_state = status
                          #question.insert_at_bottom
                        end
                      else
                        raise ImportError, "Improper weight for question #{question_row}"
                      end
                   else
                    raise ImportError, "Improper answer for question #{question_row}"
                  end
                else
                   raise ImportError, "Improper Question Type for question #{question_row}"
                end
             # end
             #end
          else
              bank_new = @root_account.assessment_question_banks.new
              bank_new.title = question_bank_title
              bank_new.workflow_state = "active"
              bank_new.save
              @bank = @root_account.assessment_question_banks.active.find(bank_new.id)
              @question_row += 1
              question = @bank.assessment_questions.new
              @assessment_question ||= {}
              if question_type == "true_false_question"
                if ans1_text !=nil && ans1_weight != nil and ans2_text !=nil && ans2_weight != nil
                  question.question_data = {:regrade_option => regrade_option,:points_possible => points_possible,
                                            :correct_comments => correct_comments,
                                            :incorrect_comments => incorrect_comments, :neutral_comments => neutral_comments,
                                            :question_type => question_type,:name => name, :question_name => question_name,
                                            :question_text => question_text,:answers => [ {:id => ans1_id,:comments => ans1_comments,
                                            :text => ans1_text,:weight => ans1_weight.to_i},  {:id => ans2_id,:comments => ans2_comments,
                                            :text => ans2_text,:weight => ans2_weight.to_i} ],:text_after_answers => text_after_answers,
                                            :assessment_question_id => assessment_question_id }
                  if ans1_weight == "100" || ans1_weight == "0" and ans2_weight == "100" || ans2_weight == "0"
                    if ans1_weight != ans2_weight
                      if question.with_versioning(&:save)
                        question.workflow_state = status
                        #question.insert_at_bottom
                      end
                    else
                      raise ImportError, "Improper weight for question #{question_row}"
                    end
                  else
                    raise ImportError, "Improper weight for question #{question_row}"
                  end
                else
                  raise ImportError, "Improper answer for question  #{question_row}"
                end
              elsif question_type == "multiple_choice_question"
                if ans1_text !=nil && ans1_weight != nil and ans2_text !=nil && ans2_weight != nil
                    question.question_data = {:regrade_option => regrade_option,:points_possible => points_possible,
                                              :correct_comments => correct_comments,
                                              :incorrect_comments => incorrect_comments, :neutral_comments => neutral_comments,
                                              :question_type => question_type,:name => name, :question_name => question_name,
                                              :question_text => question_text,:answers => [ {:id => ans1_id,:comments => ans1_comments,
                                              :text => ans1_text,:weight => ans1_weight.to_i}, {:id => ans2_id,:comments => ans2_comments,
                                              :text => ans2_text,:weight => ans2_weight.to_i} ],:text_after_answers => text_after_answers,
                                              :assessment_question_id => assessment_question_id }
                    if ans3_text !=nil && ans3_weight !=nil
                      question.question_data[:answers] << {:id => ans3_id,:comments => ans3_comments,
                                                           :text => ans3_text,:weight => ans3_weight.to_i}
                    end
                    if ans4_text !=nil && ans4_weight !=nil
                      question.question_data[:answers] << {:id => ans4_id,:comments => ans4_comments,
                                                           :text => ans4_text,:weight => ans4_weight.to_i}
                    end

                    if ans5_text !=nil && ans5_weight != nil
                      question.question_data[:answers] << {:id => ans5_id,:comments => ans5_comments,
                                                            :text => ans5_text,:weight => ans5_weight.to_i}
                    end
                    @weight_count = 0
                    if ans1_weight == "100" || ans1_weight == "0" || ans1_weight == nil and ans2_weight == "100" ||
                       ans2_weight == "0" || ans2_weight == nil and ans3_weight == "100" || ans3_weight == "0" ||
                       ans3_weight == nil and ans4_weight == "100" || ans4_weight == "0" || ans4_weight == nil and
                       ans5_weight == "100" || ans5_weight == "0" || ans5_weight == nil
                      if ans1_weight == "100"
                        @weight_count +=1
                      end
                      if ans2_weight == "100"
                        @weight_count +=1
                      end
                      if ans3_weight == "100"
                        @weight_count +=1
                      end
                      if ans4_weight == "100"
                        @weight_count +=1
                      end
                      if ans5_weight == "100"
                        @weight_count +=1
                      end
                      if @weight_count == 1
                        if question.with_versioning(&:save)
                          question.workflow_state = status
                          #question.insert_at_bottom
                        end
                      else
                        raise ImportError, "Improper weight for question #{question_row}"
                      end
                    else
                      raise ImportError, "Improper weight for question #{question_row}"
                    end
                else
                  raise ImportError, "Improper answer for question #{question_row}"
                end
              elsif question_type == "short_answer_question"
                if ans1_text !=nil && ans1_weight != nil and ans2_text !=nil && ans2_weight != nil
                  question.question_data = {:regrade_option => regrade_option,:points_possible => points_possible,
                                            :correct_comments => correct_comments,
                                            :incorrect_comments => incorrect_comments, :neutral_comments => neutral_comments,
                                            :question_type => question_type,:name => name, :question_name => question_name,
                                            :question_text => question_text,:answers => [ {:id => ans1_id,:comments => ans1_comments,
                                            :text => ans1_text,:weight => ans1_weight.to_i}, {:id => ans2_id,:comments => ans2_comments,
                                            :text => ans2_text,:weight => ans2_weight.to_i}],:text_after_answers => text_after_answers,
                                            :assessment_question_id => assessment_question_id }

                  if ans3_text !=nil && ans3_weight !=nil
                    question.question_data[:answers] << {:id => ans3_id,:comments => ans3_comments,
                                                         :text => ans3_text,:weight => ans3_weight.to_i}
                  end
                  if ans4_text !=nil && ans4_weight !=nil
                    question.question_data[:answers] << {:id => ans4_id,:comments => ans4_comments,
                                                         :text => ans4_text,:weight => ans4_weight.to_i}
                  end

                  if ans5_text !=nil && ans5_weight != nil
                    question.question_data[:answers] << {:id => ans5_id,:comments => ans5_comments,
                                                         :text => ans5_text,:weight => ans5_weight.to_i}
                  end
                  if ans1_weight == "100" ||  ans1_weight == nil and ans2_weight == "100" ||
                      ans2_weight == nil and ans3_weight == "100" || ans3_weight == nil and
                      ans4_weight == "100" || ans4_weight == nil and ans5_weight == "100" || ans5_weight == nil
                    if question.with_versioning(&:save)
                      question.workflow_state = status
                      #question.insert_at_bottom
                    end
                  else
                    raise ImportError, "Improper weight for question #{question_row}"
                  end
                else
                  raise ImportError, "Improper answer for question #{question_row}"
                end
              elsif question_type == "multiple_answers_question"
                if ans1_text !=nil && ans1_weight != nil and ans2_text !=nil && ans2_weight != nil
                    question.question_data = {:regrade_option => regrade_option,:points_possible => points_possible,
                                              :correct_comments => correct_comments,
                                              :incorrect_comments => incorrect_comments, :neutral_comments => neutral_comments,
                                              :question_type => question_type,:name => name, :question_name => question_name,
                                              :question_text => question_text,:answers => [ {:id => ans1_id,:comments => ans1_comments,
                                              :text => ans1_text,:weight => ans1_weight.to_i},  {:id => ans2_id,:comments => ans2_comments,
                                              :text => ans2_text,:weight => ans2_weight.to_i} ],:text_after_answers => text_after_answers,
                                              :assessment_question_id => assessment_question_id }
                    if ans3_text !=nil && ans3_weight !=nil
                      question.question_data[:answers] << {:id => ans3_id,:comments => ans3_comments,
                                                           :text => ans3_text,:weight => ans3_weight.to_i}
                    end
                    if ans4_text !=nil && ans4_weight !=nil
                      question.question_data[:answers] << {:id => ans4_id,:comments => ans4_comments,
                                                           :text => ans4_text,:weight => ans4_weight.to_i}
                    end
                    if ans5_text !=nil && ans5_weight != nil
                      question.question_data[:answers] << {:id => ans5_id,:comments => ans5_comments,
                                                           :text => ans5_text,:weight => ans5_weight.to_i}
                    end
                    if ans1_weight == "100" || ans1_weight == "0" || ans1_weight == nil and ans2_weight == "100" ||
                       ans2_weight == "0" || ans2_weight == nil and ans3_weight == "100" || ans3_weight == "0" ||
                       ans3_weight == nil and ans4_weight == "100" || ans4_weight == "0" || ans4_weight == nil and
                       ans5_weight == "100" || ans5_weight == "0" || ans5_weight == nil
                      if question.with_versioning(&:save)
                        question.workflow_state = status
                        #question.insert_at_bottom
                      end
                    else
                      raise ImportError, "Improper weight for question #{question_row}"
                    end
                else
                  raise ImportError, "Improper answer for question #{question_row}"
                end
              else
                raise ImportError, "Improper Question Type for question #{question_row}"
              end
             # end
             #end
          end
        end

        if question.save
          @success_count += 1

          if question_tag.present?
            @question_tag_split = question_tag.split(',')
            @question_tag_split.each do  |splait_tag|
            @question_tag = tag_tokens_new(splait_tag)
            @question_tag.each do |tag|
              @question_tag_id = tag[:id].to_s
            end
            #@question_tag_id = @question_tag[:id]
            tag_list(@question_tag_id, question, question.assessment_question_bank)  unless @question_tag_id.nil?
          end
          end
        else
          raise ImportError, question
        end

      end

      #def tag_tokens_new(query)
      #  tags = ActsAsTaggableOn::Tag.named_like(query,@root_account.id)
      #  if tags.empty?
      #    [{id: "<<<#{query}>>>", name: "New: \"#{query.strip.gsub(' ', '-')}\""}]
      #  else
      #    #tags.map(&:attributes)
      #    tags.map{ |tag| {:id => tag.id}}
      #  end
      #end
      #
      #def tag_list(tag_tokens, taggable, tagger)
      #  tags_list= tag_tokens.gsub!(/<<<(.+?)>>>/) { ActsAsTaggableOn::Tag.find_or_create_by_name_and_account_id(name: $1.strip.gsub(' ', '-'),
      #                                    account_id: @root_account.id).id }
      #  if tags_list.nil?
      #    delete_tags(taggable,tag_tokens)
      #    tag_tokens.split(",").map do |n|
      #      ActsAsTaggableOn::Tagging.find_or_create_by_tag_id_and_taggable_id_and_taggable_type_and_context(tag_id: n.to_i,
      #                                   taggable_id: taggable.id, taggable_type: taggable.class.name,
      #                                   context: "tags",tagger_id: tagger.id,tagger_type: tagger.class.name)
      #    end
      #  else
      #    tags_list.split(",").map do |n|
      #      ActsAsTaggableOn::Tagging.find_or_create_by_tag_id_and_taggable_id_and_taggable_type_and_context(tag_id: n.to_i,
      #                                taggable_id: taggable.id, taggable_type: taggable.class.name,
      #                                 context: "tags",tagger_id: tagger.id,tagger_type: tagger.class.name)
      #    end
      #  end
      #
      #end
      #



    end

  end
end
