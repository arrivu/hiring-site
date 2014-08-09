module ArrivuSubscription
	module AccountExtensions
		def self.included base
			base.class_eval do

        has_many :billing_types
        has_many :feature_sets
        has_many :subscription_plans
        has_many :payments

      end
    end
	end
end
