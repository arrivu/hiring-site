class SubscriptionController < ApplicationController

  def subscription_expired
    @subscription_id=Subscription.find_by_account_id(@domain_root_account.id).id
  end

  def subscription_expired_email
    sm=SubscriptionMessage.new
    sm.subscription_id=params[:subscription_id]
    @subscription_id=params[:subscription_id]
    sm.message=params[:message]
    sm.save
    m=Message.new
    m.subject="#{@domain_root_account.name} demo has expired"
    #m.to = Account.site_admin.pseudonyms.first.unique_id
    m.to = SubscriptionConfig.find(1).email
    body = params[:message]
    m.html_body=body
    Mailer.deliver_message(m)
    flash[:notice] = "We will be in touch with you very soon!!!"
    respond_to do |format|
      format.html {render :action => SubscriptionConfig.find(1).redirect_url }
    end
  end

  def new
    return redirect_to(root_url) if @current_user
    @subscription=Subscription.new
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.subdomain=params[:subscription][:subdomain].downcase.gsub(' ','')
    recap = Canvas::Plugin.find('registration_form_recaptcha')
    captcha_valid=true
    if recap && !recap.settings[:public_key].blank? && !recap.settings[:private_key].blank?
      captcha_valid=verify_recaptcha(:model => @demo, :private_key => recap.settings[:private_key])
    end
    if captcha_valid
      @account = Account.find_by_name(@subscription.subdomain)
      unless @account
        if @subscription.save
          password=(0...10).map{ ('a'..'z').to_a[rand(26)] }.join
          @account = Account.new
          @account.name = @subscription.subdomain
          @account.settings[:demo_account]= true
          @account.save
          @domain_root_account=@account
          @subscription.account_id=@account.id
          @subscription.save
          save_subscription_account_settings
          @pseudonym = @account.pseudonyms.active.custom_find_by_unique_id(params[:subscription][:email])
          @user = @pseudonym  ? @pseudonym .user : User.create!(:name => params[:subscription][:email],
                                                           :sortable_name => params[:subscription][:email])
          @user.register! unless @user.registered?
          unless @pseudonym
            @pseudonym = @user.pseudonyms.create!(:unique_id => params[:subscription][:email],
                                                :password => password, :password_confirmation => password,
                                                :account => @account )
            @user.communication_channels.create!(:path => params[:subscription][:email]) { |cc| cc.workflow_state = 'active' }
            @user.save!

          end
          res = @pseudonym.save!
          @account.add_user(@user, 'AccountAdmin')
        #  send_email(params[:subscription][:email],params[:subscription][:name],password,params[:subscription][:subdomain])
          reset_session_for_login
          cross_domain_login_token = AutoHandle.generate(nil, 150)
          create_subscription_authentication(@account.name,@pseudonym.unique_id,password,cross_domain_login_token)
           redirect_to url_for(:controller => "subscription", :action => "authenticate", :subdomain => @account.name,:cross_domain_login_token => cross_domain_login_token)
           else
          respond_to do |format|
            format.html {render :action => "new"}
          end
        end
      else
        respond_to do |format|
          flash[:error] = "Domain Name Already Exists.Please choose a different name"
          format.html {render :action => "new"}
        end
      end
      else
        respond_to do |format|
          flash[:error] = "Invalid Captcha"
          format.html {render :action => "new"}
        end
    end
  end

  def validate
    if params[:field].blank? || params[:value].blank?
      render :nothing => true
    else
      @valid = Account.validate_field(params[:field], params[:value])
      render :json => @valid
    end
  end

  def successful_login( pseudonym)
    @current_pseudonym = pseudonym
    flash[:notice] = "Please check your email to use Sublime account"
    redirect_to root_url
  end

  def create_subscription_authentication(account_name,unique_id,password,token)
    authenticate_subscription=AuthenticateSubscription.new
    authenticate_subscription.account_name = account_name
    authenticate_subscription.unique_id = unique_id
    authenticate_subscription.password = password
    authenticate_subscription.token =token
    authenticate_subscription.save!

  end

  def authenticate
    unless params[:cross_domain_login_token].nil?
      if authenticate_subscription = AuthenticateSubscription.find_by_token(params[:cross_domain_login_token]) && AuthenticateSubscription.find_by_account_name(current_subdomain)
          reset_session_for_login
          login={:unique_id => authenticate_subscription.unique_id,:password=> authenticate_subscription.password,:remember_me=>"0"}
          @pseudonym_session = @domain_root_account.pseudonym_sessions.new(login)
          @pseudonym_session.remote_ip = request.remote_ip
          @pseudonym_session.save!
          @pseudonym = @pseudonym_session && @pseudonym_session.record
          authenticate_subscription.destroy
          successful_login(@pseudonym)
      end
    end
  end


  private

  def send_email(to,name,password,subdomain)
    m=Message.new
    m.subject="Your Sublime free subscription details"
    m.to = to
    body = "Hi #{name}<br>"
    body=body+"Your username is #{to}<br>"
    body=body+"Your password is #{password}<br>"
    body=body+"<a href=\"#{request.protocol}#{subdomain}.#{current_domain}\">Please visit your demo here</a><br>"
    m.html_body=body
    Mailer.deliver_message(m)
  end

  def save_subscription_account_settings
    @subscription_settings =SubscriptionAccountSetting.new
    @subscription_settings.subscription_id =@subscription.id
    @subscription_settings.remarks="Free Subscription"
    @subscription_settings.start_at=Time.now
    @subscription_settings.end_at=Time.now + 365.days
    @subscription_settings.save
  end




end