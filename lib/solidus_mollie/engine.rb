module SolidusMollie
  class Engine < Rails::Engine
    require "solidus_core"
    isolate_namespace Spree
    engine_name 'solidus_mollie'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer "solidus_mollie.register.payment_methods", :after => 'spree.register.payment_methods' do |app|
      app.config.spree.payment_methods += [Spree::PaymentMethod::MolliePayments]
    end
  end
end
