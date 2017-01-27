module Snappea
  include Rails.application.routes.url_helpers

  class API < Grape::API
    version 'v1', using: :param
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    helpers do
      def authorize api_key
        @api_key = ApiKey.find_by(guid: api_key)
        unless @api_key
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
        authorize params[:api_key]

        if(Restaurant.count == 0)
          @restaurants = []
          return
        end

        @last_possible_page_index = (Restaurant.count / ENV['RESTAURANT_PAGINATION_SIZE'].to_f).ceil - 1

        if params[:page].blank? || params[:page] < 0
          @page_index = 0
          @limit = ENV['RESTAURANT_PAGINATION_SIZE'].to_i
        elsif (params[:page] - 1) > @last_possible_page_index
          @page_index = @last_possible_page_index
          @limit = Restaurant.count % ENV['RESTAURANT_PAGINATION_SIZE'].to_i
        else
          @page_index = params[:page] - 1
          @limit = ENV['RESTAURANT_PAGINATION_SIZE'].to_i
        end

        @restaurants = Restaurant.order(:id).limit(@limit).offset(ENV['RESTAURANT_PAGINATION_SIZE'].to_i * @page_index)
      end
    end



    resource :menu_items do
      desc 'Return a paginated list of restaurants.'

      params do
        requires :api_key, type: String
        optional :page, type: Integer
      end

      get '/restaruants/:id/menu_items', jbuilder: 'restaurants/index' do
        authorize params[:api_key]

        if(Restaurant.count == 0)
          @restaurants = []
          return
        end

        @restaurant = Restaurant.find_by(id: params[:id])


      end
    end
  end
end
