require 'rails_helper'

RSpec.describe 'Votes', type: :system do
  def create_choices
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

  def assert_ranking(*choices)
    rows = all('#poll_result tr')[1..-2]
    expect(rows.size).to eq choices.size
    rows.each_with_index do |row, i|
      within row do
        expect(find('th').text).to eq choices[i]
      end
    end
  end

  context '登録時はdrag and dropしない場合' do
    example '登録するボタンでcreateできる', js: true do
      create_choices

      assert_ranking('Turboについて', 'Stimulusについて', 'Stradaについて')

      click_link '投票を作成'
      expect(page).to have_content '「Hotwire.love meetup Vol.18」に投票'
      fill_in 'User name', with: 'Alice'
      fill_in 'Comment', with: 'どれも甲乙付けがたい'
      click_button '登録する'

      within '#poll_result' do
        expect(page).to have_content 'Alice'
        expect(page).to have_content 'どれも甲乙付けがたい'
      end
      assert_ranking('Turboについて', 'Stimulusについて', 'Stradaについて')

      # TODO: 更新フォームを開く
    end
  end

  context '登録時にdrag and dropする場合' do
    example 'drag and dropでcreateできる', js: true do
      create_choices

      assert_ranking('Turboについて', 'Stimulusについて', 'Stradaについて')

      click_link '投票を作成'
      expect(page).to have_content '「Hotwire.love meetup Vol.18」に投票'
      fill_in 'User name', with: 'Alice'
      fill_in 'Comment', with: 'どれも甲乙付けがたい'

      choices = all('.StackedListItem--isDraggable')
      expect(choices.size).to eq 3
      sleep 0.5
      choices[0].drag_to choices[1]
      sleep 0.5
      within '#poll_result' do
        expect(page).to have_content 'Alice'
        expect(page).to have_content 'どれも甲乙付けがたい'
      end
      click_button '更新する'

      within '#poll_result' do
        expect(page).to have_content 'Alice'
        expect(page).to have_content 'どれも甲乙付けがたい'
      end
      assert_ranking('Stimulusについて', 'Turboについて', 'Stradaについて')
    end
  end
end
