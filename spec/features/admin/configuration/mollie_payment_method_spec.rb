require 'spec_helper'

describe "Mollie Payment Method" do
  stub_authorization!

  before(:each) do
    visit spree.admin_path
    click_link "Settings"
  end

  context "admin creating a new payment method" do
    it "should be able to create a new mollie payment method" do
      click_link "Payment Methods"
      click_link "admin_new_payment_methods_link"
      expect(page).to have_content("New Payment Method")
      fill_in "payment_method_name", :with => "Mollie Payments"
      fill_in "payment_method_description", :with => "Mollie Description"
      select "PaymentMethod::Mollie", :from => "gtwy-type"
      click_button "Create"
      expect(page).to have_content("successfully created!")
    end
  end

  context "admin can configure the mollie payment", js: true do
    before(:each) do
      Spree::PaymentMethod::MolliePayments.create!({name: "Mollie"})
      click_link "Payment Methods"
      within("table#listing_payment_methods") do
        click_icon(:edit)
      end
    end

    it "and set the mollie api key" do
      wait_for_ajax
      fill_in "payment_method_mollie_preferred_api_key", :with => "my-very-cool-key"
      click_button "Update"
      expect(page).to have_content("successfully updated!")
      expect(find_field("payment_method_mollie_preferred_api_key").value).to eql "my-very-cool-key"
    end
  end
end
