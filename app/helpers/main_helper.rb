require "headless"
require "selenium-webdriver"

module MainHelper
  def self.browser_stuff folders_s, email
    attempts = 0
    begin
      browser_stuff_helper folders_s, email
    rescue
      attempts += 1
      retry if attempts<3
    else
      attempts = 73
    end
    
    browser_stuff_helper folders_s, email if attempts!=73
  end
  
  def self.browser_stuff_helper folders_s, email
    # TODO: Probably there's a better way of doing this
    app_config = YAML.load_file("#{Rails.root}/config/config.yml")
    
    headless = Headless.new
    headless.start
    
    driver = Selenium::WebDriver.for :firefox
    begin
      driver.manage.timeouts.implicit_wait = 10
      driver.navigate.to "http://dropbox.com/login"
    
      driver.execute_script("document.getElementsByName('login_email')[1].value = '#{app_config["DROPBOX_EMAIL"]}'")
      driver.execute_script("document.getElementsByName('login_password')[1].value = '#{app_config["DROPBOX_PASSWORD"]}'")
      element_signin = driver.find_element(:class, "login-button")
      element_signin.click

      sleep 3
    
      folders_s.each do |folder|
        folder[:subfolders].each do |subfolder|
          driver.navigate.to "http://dropbox.com/home/LMAC/#{folder[:name]}/#{subfolder[:name]}"
          share_button = driver.find_element(:id, "global_share_button")
          share_button.click

          email_input = driver.find_element(:id, "sharing-options-new-collab-input")
          email_input.click
          driver.execute_script("document.getElementById('sharing-options-new-collab-input').value = '#{email}'")
          
          sleep 3
          send_button = driver.find_element(:xpath, "//button[text()='Send invites']")
          send_button.click
        end
      end
    
      driver.navigate.to "http://dropbox.com/logout"
    ensure
      driver.quit
    end
    headless.destroy
  end
end
