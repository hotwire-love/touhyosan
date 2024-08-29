require 'rails_helper'

RSpec.describe 'Choices', type: :system do
  example 'CRUDができる', :js do
    visit root_path

    fill_in 'Title', with: 'Hotwire.love meetup Vol.35'
    click_button '登録する'
    expect(page).to have_selector 'h2', text: 'Hotwire.love meetup Vol.35'

    # Create
    fill_in '新しい選択肢', with: 'Turboについて'
    click_button '登録する'
    within '#poll-choices' do
      expect(page).to have_selector 'li', text: 'Turboについて'
    end
    expect(page).to have_field '新しい選択肢', with: ''

    within '#poll-choices' do
      # Update
      click_link 'Turboについて'
      expect(page).to have_field 'choice[title]', with: 'Turboについて'
      fill_in 'choice[title]', with: 'Stimulusについて'
      click_button '更新する'
      expect(page).to have_selector 'li', text: 'Stimulusについて'

      # Delete
      accept_confirm { click_button '削除' }
      expect(page).to_not have_selector 'li'
    end
  end
end
