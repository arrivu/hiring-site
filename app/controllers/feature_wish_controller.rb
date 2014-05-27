class FeatureWishsController < ApplicationController
  #
  #def new
  #  @feature_wish = FeatureWish.new
  #end
  #
  #def create
  # @feature_wish = FeatureWish.create(:account_name => @current_user.account.name,:user_name => @current_user.name,
  #                                    :unique_id => @current_user.pseudonym.unique_id,:feature_clicked => params[:action],
  #                                    :clicked_at => Time.now)
  #  @feature_wish.save!
  #end

  def update
    @feature_wish = FeatureWish.find(params[:id])
  if @feature_wish.update_attributes(params[:feature_wish])
     flash[:notice] = "Your request was sent to admin,The administrator will contact you soon"
     redirect_to :back
  else
     flash[:error] = "The last request didn't work "
  end

  end
end
