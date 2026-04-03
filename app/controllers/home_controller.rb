class HomeController < ApplicationController
  def index
    @sample_drug = Drug.joins(:price_entries).order("RANDOM()").first
  end
end
