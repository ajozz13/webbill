require 'selenium-webdriver'

$driver_path = "~/apps/chromedriver/bin"
$driver = nil
$e_code = 0

##Functions
def dropdown_select_by_value id, select_value_option
  dropdown = $driver.find_element( :id, id );
  options = dropdown.find_elements( tag_name: 'option' )
  options.each { |option| option.click if option.attribute( "value" ).to_s == select_value_option }  #select by value
  selected_option = options.map { |option| option.text if option.selected? }.join
end

def dropdown_select_by_text id, select_text_option
  dropdown = $driver.find_element( :id, id );
  options = dropdown.find_elements( tag_name: 'option' )
  options.each { |option| option.click if option.text == select_text_option }  #select by text
  selected_option = options.map { |option| option.text if option.selected? }.join
end

#This is a slower more effective way to type than to just find_element.send_keys
def send_text type, id, send_txt
  ele = $driver.find_element( type, id )
  send_txt.scan( /./ ).each { |t|
    ele.send_keys t
  }
end

def click xpath
  $driver.find_element( :xpath, xpath ).click
end
