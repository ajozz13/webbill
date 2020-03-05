require 'minitest/autorun'
require_relative 'globals'

describe "I can open a web browser and write?" do
  before do
    init_driver
  end

  describe "it can read and write" do
    it "can write account_number" do
      $driver.navigate.to "file:///data/work/webbill/index.html"
      is_displayed( :id, 'ship_account' ).must_equal true
      send_text :id, 'ship_account', '8040'
      send_text :id, 'ship_reference', '111234'
      get_input_value( :id, 'ship_account' ).must_equal '8040'
    end
  end

end
