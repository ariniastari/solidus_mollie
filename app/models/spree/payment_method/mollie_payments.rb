module Spree
  class PaymentMethod::MolliePayments < PaymentMethod
    preference :api_key, :string

    def payment_profiles_supported?
      false
    end

    def cancel(*)
    end

    def source_required?
      true
    end

    def credit(*)
      self
    end

    def success?
      true
    end

    def authorization
      self
    end
  end
end
