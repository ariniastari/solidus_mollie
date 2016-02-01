require 'mollie'
Spree::CheckoutController.class_eval do
  before_action :handle_mollie, only: :update

  private

  def handle_mollie
    # setup mollie transaction to be used in the confirm step.
    if params[:state] == 'payment'
      binding.pry
      mollie = SolidusMollie::PaymentService.mollie_client

      amount = @order.total.to_f
      description = "Order #{@order.number}"
      redirect_url = confirm_mollie_status_url(@order)

      method = params[:order][:payments_attributes].first[:mollie_method_id]
      method_params = {}
      mollie_response = mollie.prepare_payment(amount, description, redirect_url, {order_id: @order.number}, method, method_params)

      mollie_transaction = MollieTransaction.create!({
        payment_method_id: method,
        transaction_id: mollie_response["id"]
      })

      @order.payments.not_store_credits.destroy_all
      payment = @order.payments.create({:amount => @order.total,
                                       :source => mollie_transaction,
                                       :payment_method => Spree::PaymentMethod::MolliePayments.first}
                                       )
      payment.started_processing!
      payment.pend!

    elsif params[:state] == 'confirm'
      # assuming the last pending payment is the mollie payment.
      # TODO make sure it's actually the mollie payment. Since there could be
      # store_credit payments as well.
      @order.payments.where(source: nil).destroy_all
      payment = @order.payments.pending.last
      url_txn = payment.source.transaction_id.gsub('tr_','')
      redirect_to "https://www.mollie.nl/payscreen/pay/#{url_txn}"
    end
    return
  end
end
