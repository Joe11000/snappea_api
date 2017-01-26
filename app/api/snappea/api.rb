module Snappea
  include Rails.application.routes.url_helpers

  class API < Grape::API
    version 'v1', using: :param
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    helpers do
      def authorize api_key
        unless ApiKey.find_by(guid: api_key)
          return error!('401 Unauthorized', 401)
        end
      end
    end

    resource :restaurants do
      desc 'Return a paginated list of restaurants.'

      params do
        requires :api_key, type: String
        optional :page, type: Integer
      end

      get '/', jbuilder: 'restaurants/index' do
        @RESTAURANT_PAGINATION_SIZE = 4
        authorize params[:api_key]

        if(Restaurant.count == 0)
          @restaurants = []
          return
        end

        @last_possible_page_index = (Restaurant.count / @RESTAURANT_PAGINATION_SIZE.to_f).ceil - 1

        if params[:page].blank? || params[:page] < 0
          @page_index = 0
          @limit = @RESTAURANT_PAGINATION_SIZE
        elsif (params[:page] - 1) > @last_possible_page_index
          @page_index = @last_possible_page_index
          @limit = Restaurant.count % @RESTAURANT_PAGINATION_SIZE
        else
          @page_index = params[:page] - 1
          @limit = @RESTAURANT_PAGINATION_SIZE
        end

        @restaurants = Restaurant.order(:id).limit(@limit).offset(@RESTAURANT_PAGINATION_SIZE * @page_index)
      end
    end
  end
end
