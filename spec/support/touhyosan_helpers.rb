module TouhyousanHelpers
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
end
