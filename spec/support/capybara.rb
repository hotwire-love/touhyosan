require 'capybara-playwright-driver'

# setup
Capybara.register_driver(:playwright) do |app|
  Capybara::Playwright::Driver.new(app, browser_type: :chromium, headless: false)
  # Capybara::Playwright::Driver.new(app, browser_type: :firefox, headless: false)
end
# Capybara.default_max_wait_time = 15
# Capybara.default_driver = :playwright
Capybara.save_path = 'tmp/capybara'

# run
# Capybara.app_host = 'https://github.com'
# visit '/'
# fill_in('q', with: 'Capybara')

## [REMARK] We can use Playwright-native selector and action, instead of Capybara DSL.
# find('a[data-item-type="global_search"]').click
# page.driver.with_playwright_page do |page|
#   page.click('a[data-item-type="global_search"]')
# end

# all('.repo-list-item').each do |li|
#   #puts "#{li.all('a').first.text} by Capybara"
#   puts "#{li.with_playwright_element_handle { |handle| handle.query_selector('a').text_content }} by Playwright"
# end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    # driver = ENV['NO_HEADLESS'] ? :selenium_chrome : :selenium_chrome_headless
    # driven_by driver
    driven_by :playwright
  end
end
