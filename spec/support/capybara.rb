Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(app, browser_type: :chromium, headless:  !ENV['NO_HEADLESS'])
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :playwright
  end
end
