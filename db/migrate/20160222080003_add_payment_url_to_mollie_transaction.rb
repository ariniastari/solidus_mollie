class AddPaymentUrlToMollieTransaction < ActiveRecord::Migration
  def change
    add_column :mollie_transactions, :payment_url, :string
  end
end
