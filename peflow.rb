require 'selenium-webdriver'
require 'pp'

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

while true
  print '> '
  url = STDIN.gets
  break if url.chomp == "exit"

  puts "GET #{url}"
  driver.get url

  puts '# show available types'
  puts driver.manage.logs.available_types

  puts '# show performance logs'
  pp driver.manage.logs.get(:performance)
      .map{|log| JSON.parse(log.message)['message']}
      .select{|log| log['method'] == 'Network.responseReceived'}
      .map{|log| {
        timestamp: log.dig('params', 'timestamp'),
        url: log.dig('params', 'response', 'url'),
        method: log.dig('params', 'response', 'requestHeaders', ':method'),
        status: log.dig('params', 'response', 'status'),
        protocol: log.dig('params', 'response', 'protocol'),
        type: log.dig('params', 'type'),
        connectionId: log.dig('params', 'response', 'connectionId'),
        timing: log.dig('params', 'response', 'timing')}
      }
end

driver.close
