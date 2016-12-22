require 'selenium-webdriver'

caps = Selenium::WebDriver::Remote::Capabilities.chrome({
  loggingPrefs: {
    browser: 'ALL',
    driver: 'ALL',
    performance: 'ALL'
  },
  chromeOptions: {
    perfLoggingPrefs: {
      enableNetwork: true,
      enablePage: true,
      enableTimeline: true
    }
  }
})

driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
driver.get 'https://www.google.com'

puts driver.manage.logs.available_types

driver.manage.logs.available_types.each do |type|
  puts '==========================================================================='
  driver.manage.logs.get(type).each do |log|
    p log.as_json
  end
  puts '==========================================================================='
end

driver.close
