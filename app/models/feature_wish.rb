class FeatureWish < ActiveRecord::Base
  attr_accessible :account_name ,:user_name ,:unique_id ,:feature_clicked ,:clicked_at ,:submited_to_admin, :course
end
