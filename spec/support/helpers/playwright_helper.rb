module PlaywrightHelper
  def playwright_wait_for(selector:, state: :visible, timeout: 0)
    Capybara.current_session.driver.with_playwright_page do |page|
      locator = page.locator(selector)
      locator.wait_for(state:, timeout:)
    end
  end
end
