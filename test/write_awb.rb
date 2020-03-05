# Simple selenium test to generate an Airwaybill
# requires Selenium and Chromedriver
require 'selenium-webdriver'


$driver_path = "~/apps/chromedriver/bin"
@driver = nil
e_code = 0

##Functions
def dropdown_select_by_value id, select_value_option
  dropdown = @driver.find_element( :id, id );
  options = dropdown.find_elements( tag_name: 'option' )
  options.each { |option| option.click if option.attribute( "value" ).to_s == select_value_option }  #select by value
  selected_option = options.map { |option| option.text if option.selected? }.join
end

def dropdown_select_by_text id, select_text_option
  dropdown = @driver.find_element( :id, id );
  options = dropdown.find_elements( tag_name: 'option' )
  options.each { |option| option.click if option.text == select_text_option }  #select by text
  selected_option = options.map { |option| option.text if option.selected? }.join
end

#This is a slower more effective way to type than to just find_element.send_keys
def send_text type, id, send_txt
  ele = @driver.find_element( type, id )
  send_txt.scan( /./ ).each { |t|
    ele.send_keys t
  }
end

def click xpath
  @driver.find_element( :xpath, xpath ).click
end


##MAIN
begin

  dp = File.expand_path( $driver_path )
  puts "Driver Path: #{ dp }"
  Selenium::WebDriver::Chrome::Service.driver_path= "#{ dp }/chromedriver"

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument( '--start-maximized' )

  @driver = Selenium::WebDriver.for :chrome, options: options
  @driver.navigate.to "file:///data/work/webbill/index.html"

  ##Fill  the form
  send_text :id, 'ship_account', '8040'
  send_text :id, 'ship_reference', '111234'
  send_text :id, 'ship_name', 'Alberto Ochoa'
  send_text :id, 'ship_company_name', 'IBC'
  send_text :id, 'ship_address', '8401 NW 17th St'
  send_text :id, 'ship_city', 'Miami'
  send_text :id, 'ship_state', 'FL'
  send_text :id, 'ship_zip', '33035'
  send_text :xpath, '/html/body/div[1]/div[3]/div[1]/form/div[1]/div[5]/div[1]/div/input[2]', 'US'
  send_text :id, 'ship_phone', '305-591-8080'

  send_text :id, 'con_name', 'Jaime Baily'
  send_text :id, 'con_company_name', 'Mega'
  send_text :id, 'con_address', '11 East Dr'
  send_text :id, 'con_city', 'Ft. Lauderdale'
  send_text :id, 'con_state', 'FL'
  send_text :id, 'con_zip', '11234'
  send_text :xpath, '/html/body/div[1]/div[3]/div[1]/form/div[2]/div[4]/div[1]/div/input[2]', 'US'
  send_text :id, 'con_phone', '305-755-2177'

  send_text :id, 'description', 'Books and Pens'
  dropdown_select_by_value 'contents', 'APX'
  send_text :id, 'value', '10'
  send_text :id, 'dw', '3'
  send_text :id, 'piece_dimension', '4x5x6'

  click "//button[contains(@class, 'green button')]"
  click "//button[contains(@class, 'blue button')]"
  sleep 2
  puts "AWB Created? #{ @driver.find_element( :id, 'awbmodal' ).displayed? }"
  puts "AWB# #{ @driver.find_element( :xpath, '//*[@id="awbcontent"]/div/div[1]/div[2]/p' ).text }"
  click "//div[contains(@class, 'cancel button')]"
  sleep 2

rescue Exception => e
  puts "Exception: #{e}"
  puts e.backtrace
  e_code = 1
ensure
  #driver.quit
  exit e_code
end
