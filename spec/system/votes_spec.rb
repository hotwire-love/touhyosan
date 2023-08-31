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

  def drag_choice(from:, to:)
    choices = all('.StackedListItem--isDraggable')
    wait_for_turbo
    choices[from].drag_to choices[to]
    wait_for_turbo
  end

  def wait_for_turbo
    sleep 0.5
  end

  context '登録時はdrag and dropしない場合' do
    example '登録するボタンでcreateできる', js: true do
      create_choices

      assert_ranking('Turboについて', 'Stimulusについて', 'Stradaについて')

      click_link '投票を作成'
      expect(page).to have_content '「Hotwire.love meetup Vol.18」に投票'
      wait_for_turbo
      fill_in 'User name', with: 'Alice'
      fill_in 'Comment', with: 'どれも甲乙付けがたい'
      click_button '登録する'

      expect(page).to have_content '投票を作成しました'

      within '#poll_result' do
        expect(page).to have_content 'Alice'
        expect(page).to have_content 'どれも甲乙付けがたい'
      end
      assert_ranking('Turboについて', 'Stimulusについて', 'Stradaについて')

      click_link 'Alice'
      expect(page).to have_content '「Hotwire.love meetup Vol.18」に投票'
      wait_for_turbo
      fill_in 'User name', with: 'ありす'
      fill_in 'Comment', with: '迷うわ〜'
      click_button '更新する'

      expect(page).to have_content '投票を更新しました'

      within '#poll_result' do
        expect(page).to have_content 'ありす'
        expect(page).to have_content '迷うわ〜'
      end
      assert_ranking('Turboについて', 'Stimulusについて', 'Stradaについて')
    end
  end

  context '登録時にdrag and dropする場合' do
    example 'drag and dropでcreateできる', js: true do
      create_choices

      assert_ranking('Turboについて', 'Stimulusについて', 'Stradaについて')

      # 登録フォーム内でdrag and drop
      click_link '投票を作成'
      expect(page).to have_content '「Hotwire.love meetup Vol.18」に投票'
      wait_for_turbo
      fill_in 'User name', with: 'Alice'
      fill_in 'Comment', with: 'どれも甲乙付けがたい'

      drag_choice(from: 0, to: 1)
      within '#poll_result' do
        expect(page).to have_content 'Alice'
        expect(page).to have_content 'どれも甲乙付けがたい'
      end
      assert_ranking('Stimulusについて', 'Turboについて', 'Stradaについて')
      click_button '更新する'

      within '#poll_result' do
        expect(page).to have_content 'Alice'
        expect(page).to have_content 'どれも甲乙付けがたい'
      end

      # 更新フォーム内でdrag and drop
      click_link 'Alice'
      expect(page).to have_content '「Hotwire.love meetup Vol.18」に投票'
      wait_for_turbo

      drag_choice(from: 1, to: 2)
      assert_ranking('Stimulusについて', 'Stradaについて', 'Turboについて')

      drag_choice(from: 0, to: 1)
      assert_ranking('Stradaについて', 'Stimulusについて', 'Turboについて')
    end
  end
end
