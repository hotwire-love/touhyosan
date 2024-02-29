module PrepollsHelper

  def get_editor
    session[:editor]
  end

  def make_table(pre_poll)
    max_col = pre_poll.proposals.size
    max_col = 0 unless max_col
    max_row = pre_poll.proposals.map { |proposal| proposal.choiceitems.size }.max
    max_row = 0 unless max_row

    initial_value = ["", false]
    array = Array(size: max_row, val: initial_value)

    0.upto(max_row - 1) do |count|
      array[count] = Array(max_col)
    end
    pre_poll.proposals.default_order.each_with_index do |proposal, ind_c| 
      proposal.choiceitems.default_order.each_with_index do |choiceitem, ind_r| 
        array[ind_r][ind_c] = [choiceitem.title, choiceitem.accepted]
      end
    end

    [array, max_col, max_row, initial_value]
  end
end
