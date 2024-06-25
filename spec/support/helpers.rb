Dir[File.join(File.dirname(__FILE__), 'helpers', '*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.include PlaywrightHelper, type: :system
end
