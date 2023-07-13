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

    click_link '投票を作成'
    expect(page).to have_content '「Hotwire.love meetup Vol.18」に投票'
    fill_in 'User name', with: 'Alice'
    # TODO: drag and dropする
    fill_in 'Comment', with: 'どれも甲乙付けがたい'
    click_button '登録する'

    within '#poll_result' do
      expect(page).to have_content 'Alice'
      expect(page).to have_content 'どれも甲乙付けがたい'
    end
  end
end
