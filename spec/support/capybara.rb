RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driver = ENV['NO_HEADLESS'] ? :selenium_chrome : :selenium_chrome_headless
    driven_by driver
  end
end
