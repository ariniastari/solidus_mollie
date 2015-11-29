require 'mollie'

module SolidusMollie
  class PaymentService

    def self.mollie_payment_methods
      mollie_client.payment_methods['data']
    end

    private
    def self.mollie_client
      @client ||= begin
        api_key = Spree::PaymentMethod::MolliePayments.first.get_preference(:api_key)
        Mollie::Client.new(api_key)
      end
    end
  end
end
