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
  module CSV
    class AssessmentQuestionImporter < CSVBaseImporter

      def self.is_assessment_question_csv?(row)
         row.include?('question_bank_title') &&  row.include?('name')
      end

      def process(csv)
        @sis.counts[:assessment_questions] += SIS::AssessmentQuestionImporter.new(@root_account, importer_opts).process do |importer|
          csv_rows(csv) do |row|
            update_progress

            begin
              importer.add_assessment_question(row['question_bank_title'],
                                               row['question_data'],row['regrade_option'],row['points_possible'],row['tags'],
                                               row['correct_comments'],row['incorrect_comments'],row['neutral_comments'],
                                               row['question_type'],row['name'],row['question_name'],row['question_text'],row['status'],
                                               row['answers'],row['ans1_id'],row['ans1_comments'],row['ans1_text'],row['ans1_weight'],
                                               row['ans2_id'],row['ans2_comments'],row['ans2_text'],row['ans2_weight'],
                                               row['ans3_id'],row['ans3_comments'],row['ans3_text'],row['ans3_weight'],
                                               row['ans4_id'],row['ans4_comments'],row['ans4_text'],row['ans4_weight'],
                                               row['ans5_id'],row['ans5_comments'],row['ans5_text'],row['ans5_weight'],
                                               row['text_after_answers'],row['assessment_question_id'])

            rescue ImportError => e
              add_warning(csv, "#{e}")
            end
          end
        end
      end
    end
  end
end

