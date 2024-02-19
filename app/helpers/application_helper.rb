module ApplicationHelper
  def make_array(pre_poll)
    max_col = pre_poll.proposals.size
    max_col = 0 unless max_col
    max_row = pre_poll.proposals.map { |proposal| proposal.choiceitems.size }.max
    max_row = 0 unless max_row

    max_row += 1
    array = Array(max_row)

    0.upto(max_row - 1) do |i|
      array[i] = Array(max_col)
    end

    pre_poll.proposals.default_order.each_with_index do |proposal, ind_c|
      if array[ind_c]
        row_index = 0
        array[ind_c][row_index] = %!<th>#{link_to proposal.user_name,
                                                  new_pre_poll_proposal_path(proposal),
                                                  data: { turbo_frame: "proposal_form" }}</th>!
        row_index += 1
        proposal.choiceitems.default_order.each { |choiceitem|
          array[ind_c][row_index] = if choiceitem.accepted?
              %!<td class="accepted">#{choiceitem.title}</td>!
            else
              %!<td>#{choiceitem.title}</td>!
            end
          row_index += 1
        }
      end
    end
    [array, max_row]
  end

  def make_html(pre_poll)
    array, max_row = make_array(pre_poll)
    html = ""
    html += %(<table id="proposal_result" class="table">)

    0.upto(max_row - 1) do |index|
      html += "<tr>#{array[index].join("")}</tr>"
    end
    html += %(</table>)
    html
  end

  def current_editor
    session[:editor]
  end
end
