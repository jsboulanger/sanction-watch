
# View's Helpers
module Helpers
  def pagination_links(search_results, current_page)
    html = ""
    (1..((search_results.total_hits / RESULTS_PER_PAGE).ceil + 1)).each do |i|
      if i == current_page.to_i
        html << '<span class="page current_page">' + i.to_s + '</span>'
      else
        html << '<a class="page" href="?' + Rack::Utils.build_query(Rack::Utils.parse_query(request.query_string).merge('page' => i)) + '">' + i.to_s + '</a>'
      end
    end
    html
  end

  def results_range(search_results, current_page)
    first_result = (current_page - 1) * RESULTS_PER_PAGE + 1
    last_result = first_result + RESULTS_PER_PAGE - 1
    last_result = search_results.total_hits if search_results.total_hits < last_result
    "#{first_result}-#{last_result}"
  end
end

