require 'rails_helper'

RSpec.describe 'Votes', type: :system do
  example '話したいネタを作成して、投票ができる' do
    visit root_path

    fill_in 'Title', with: 'Hotwire.love meetup Vol.18'
    fill_in 'Choices text', with: <<~TEXT
      Turboについて
      Stimulusについて
      Stradaについて
    TEXT
    click_button '登録する'

    within '#poll_result' do
      expect(page).to have_content 'Turboについて'
      expect(page).to have_content 'Stimulusについて'
      expect(page).to have_content 'Stradaについて'
    end
  end
end
