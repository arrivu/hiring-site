class AddSmsSettingsTable < ActiveRecord::Migration
	tag :predeploy
	def self.up
		create_table "sms_settings", :force => true do |t|
			t.integer  "account_id",:limit => 8
			t.string   "url"
			t.string   "user_name"
			t.string   "password"
		end
	end

end
