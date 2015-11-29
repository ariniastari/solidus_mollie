Spree::Core::Engine.routes.draw do
  get 'mollie/confirm/:order_id', to: 'mollie_status#confirm', as: 'confirm_mollie_status'
end
