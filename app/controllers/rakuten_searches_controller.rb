class RakutenSearchesController < ApplicationController
  def index
    @keyword = params[:keyword].to_s.strip

    if @keyword.present?
      page = (params[:page] || 1).to_i
      cache_key = "rakuten_search/#{@keyword.parameterize}/page#{page}"
      @items = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
        RakutenWebService::Ichiba::Item.search(
          keyword: @keyword,
          page:    page,
          hits:    20
        ).to_a
      end
    else
      @items = []
    end
  end
end
