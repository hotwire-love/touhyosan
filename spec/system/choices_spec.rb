require 'rails_helper'

RSpec.describe 'Choices', :js, type: :system do
  def assert_ranking(*choices)
    wait_for_turbo
    rows = all('#poll_result tr')[1..-2]
    expect(rows.size).to eq choices.size
    rows.each_with_index do |row, i|
      within row do
        expect(find('th').text).to eq choices[i]
      end
    end
  end

  def wait_for_turbo
    sleep 0.5
  end

  example 'CRUDができる' do
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

    click_link '投票画面へ進む'
    expect(page).to have_link '投票を作成'
    click_link '選択肢作成画面へ戻る'
    expect(page).to have_field '新しい選択肢', with: ''
  end

  describe '投票結果テーブルへのリアルタイム反映' do
    before do
      @poll = Poll.create!(title: 'Hotwire.love meetup Vol.35')
      @choice = @poll.choices.create!(title: 'Turboについて')
      new_vote = @poll.votes.new(user_name: "Alice")
      @poll.choices.each_with_index do |choice, index|
        new_vote.vote_details.build(choice: choice, position: index)
      end
      new_vote.save!
    end

    example '選択肢のCUDがリアルタイムに反映される' do
      visit poll_path(@poll)
      assert_ranking('Turboについて')

      # Create
      using_session 'Bob' do
        visit poll_choices_path(@poll)
        expect(page).to have_selector 'h2', text: 'Hotwire.love meetup Vol.35'

        fill_in '新しい選択肢', with: 'Stimulusについて'
        click_button '登録する'
        within '#poll-choices' do
          expect(page).to have_selector 'li', text: 'Stimulusについて'
        end
      end
      assert_ranking('Turboについて', 'Stimulusについて')

      # Update
      using_session 'Bob' do
        within '#poll-choices' do
          click_link 'Turboについて'
          expect(page).to have_field 'choice[title]', with: 'Turboについて'
          fill_in 'choice[title]', with: 'About Turbo'
          click_button '更新する'
          expect(page).to have_selector 'li', text: 'About Turbo'
        end
      end
      assert_ranking('About Turbo', 'Stimulusについて')

      # Delete
      using_session 'Bob' do
        accept_confirm { first('#poll-choices button').click }
        within '#poll-choices' do
          expect(page).to_not have_selector 'li', text: 'About Turbo'
        end
      end
      assert_ranking('Stimulusについて')
    end
  end
end
