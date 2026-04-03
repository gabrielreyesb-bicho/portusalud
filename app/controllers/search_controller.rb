class SearchController < ApplicationController
  RESULTS_PER_PAGE = 20

  def index
    @query = params[:q].to_s.strip

    if @query.length >= 2
      @drugs = Drug.search_by_name_and_ingredient(@query)
                   .includes(:price_entries)
                   .limit(RESULTS_PER_PAGE)
    else
      @drugs = Drug.none
      @sample_drug = Drug.joins(:price_entries).order("RANDOM()").first
    end
  end

  def autocomplete
    @query = params[:q].to_s.strip

    @suggestions = if @query.length >= 2
      Drug.search_by_name_and_ingredient(@query).limit(8)
    else
      Drug.none
    end

    respond_to do |format|
      format.turbo_stream
    end
  end
end
