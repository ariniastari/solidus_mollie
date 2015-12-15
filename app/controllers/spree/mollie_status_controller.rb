module Spree
  class MollieStatusController < Spree::BaseController
    protect_from_forgery except: [:confirm]

    def confirm
      order = Spree::Order.find_by_number(params[:order_id])
      payment = order.payments.pending.last
      txn = payment.source.transaction_id.gsub("tr_","")

      mollie = SolidusMollie::PaymentService.mollie_client

      status = mollie.payment_status(txn)
      if status["status"] == "paid"
        payment.complete!
        order.update!
        order.complete!
        redirect_to spree.order_path(order)
      else
        redirect_to '/'
      end
    end
  end
end
