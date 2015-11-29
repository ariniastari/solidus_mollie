class CreateMollieTransactions < ActiveRecord::Migration
  def change
    create_table :mollie_transactions do |t|
      t.string :payment_method_id
      t.string :issuer_id
      t.string :transaction_id
      t.timestamps null: false
    end
  end
end
