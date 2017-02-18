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
        @api_key
      end
    end

    resource :restaurants do
      desc 'Return a paginated list of restaurants.'

      params do
        requires :api_key, type: String
        optional :page, type: Integer
      end

      get '/', jbuilder: 'restaurants/index' do
        authorize declared(params)[:api_key]

        if(Restaurant.count == 0)
          @restaurants = []
          return
        end

        @last_possible_page_index = (Restaurant.count / ENV['RESTAURANT_PAGINATION_SIZE'].to_f).ceil - 1

        if declared(params)[:page].blank? || declared(params)[:page] < 0
          @page_index = 0
          @limit = ENV['RESTAURANT_PAGINATION_SIZE'].to_i
        elsif (declared(params)[:page] - 1) > @last_possible_page_index
          @page_index = @last_possible_page_index
          @limit = Restaurant.count % ENV['RESTAURANT_PAGINATION_SIZE'].to_i
        else
          @page_index = declared(params)[:page] - 1
          @limit = ENV['RESTAURANT_PAGINATION_SIZE'].to_i
        end

        @restaurants = Restaurant.order(:id).limit(@limit).offset(ENV['RESTAURANT_PAGINATION_SIZE'].to_i * @page_index)
      end


      segment '/:id' do
        resource 'menu_items' do
          desc 'Return a paginated list of restaurants.'

          params do
            requires :api_key, type: String
            requires :id, type: Integer
          end

          get '', jbuilder: 'menu_items/index' do
            authorize declared(params)[:api_key]

            @restaurant = Restaurant.includes(menu_items: {menu_item_tags: :tag}).find_by(id: declared(params)[:id])
          end
        end
      end
    end
  end
end
