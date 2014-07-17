
class Kandanchat
  require 'net/http'
  require 'net/https'
  require 'uri'
  
  def self.config_check(settings)
    # auth = Digest::MD5.hexdigest("#{settings['secret_key']}:roomlist")
    # res = Net::HTTP.get(URI.parse("http://tinychat.apigee.com/roomlist?result=json&key=#{settings['api_key']}&auth=#{auth}"))
    # json = JSON.parse(res) rescue nil
    # if json && json['error'] && json['error'] == "invalid request"
    #   "Configuration check failed, please check your settings"
    # else
    #   nil
    # end
  end
  
  def self.config
    Canvas::Plugin.find(:kandan_chat).try(:settings)
  end
end
