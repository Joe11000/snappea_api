require 'rails_helper'

RSpec.describe Snappea::API, type: :request do

  context "GET /api/restaurants/:id/menu_items?api_key=..." do
    context 'request was unauthorized because' do
      it 'no api_key param was given and returned a 400 error json' do
        get "/api/restaurants/1/menu_items"

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq ({"error"=>"api_key is missing"})
      end

      it 'the api_key was invalid and returned a 401 error json' do
        get "/api/restaurants/1/menu_items?api_key=7"

        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)).to eq ({"error"=>"401 Unauthorized"})
      end
    end

    context 'request has an authorized api_key' do
      context 'but no restaurants exist' do
        let!(:api_key){ FactoryGirl.create(:api_key) }

        it 'return body is an empty set' do
          get "/api/restaurants/4444444/menu_items?api_key=#{api_key.guid}"

          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq ({})
        end
      end

      context 'and restaurants exist' do
        context "but the id param is a restaurant id that doesn't exist" do
          let!(:api_key){ FactoryGirl.create(:api_key) }
          let(:restaurant) { FactoryGirl.create(:restaurant) }

          it 'return body the name of the restaurant and an empty menu_items' do
            get "/api/restaurants/88888888/menu_items?api_key=#{api_key.guid}"

            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq ({})
          end
        end

        context 'but no menu_items exist' do
          let!(:api_key){ FactoryGirl.create(:api_key) }
          let(:restaurant) { FactoryGirl.create(:restaurant) }

          it 'return body the name of the restaurant and an empty menu_items' do
            get "/api/restaurants/#{restaurant.id}/menu_items?api_key=#{api_key.guid}"

            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq ({"restaurant"=> restaurant.name, "menu_items"=>[]})
          end
        end

        context 'and menu_items exist' do
          context 'but no menu_item_tags associations cooresponding to tags exist' do
            let!(:api_key){ FactoryGirl.create(:api_key) }
            before :each do
              @menu_item = FactoryGirl.create(:menu_item)
              @restaurant = @menu_item.restaurant
              unassociated_tag = FactoryGirl.create(:tag)
            end


            it 'returns the name of the restaurant and an empty menu_items' do
              get "/api/restaurants/#{@restaurant.id}/menu_items?api_key=#{api_key.guid}"

              menu_item_attrs = { 'id' => @menu_item.id, 'name' => @menu_item.name, 'description' => @menu_item.description, 'menu_category' => @menu_item.menu_category, 'tags' => [] }

              expect(response).to have_http_status(200)
              expect(JSON.parse(response.body)).to eq ({"restaurant"=> @restaurant.name, "menu_items"=> [menu_item_attrs]})
            end
          end

          context 'menu_item_tags associations cooresponding to tags exist' do
            let!(:api_key){ FactoryGirl.create(:api_key) }

            before :each do
              # create one restaurant with 2 menu_items. One menu_item with 2 associated tags and the other with 1 associated tag
                @mi_1 = FactoryGirl.create(:menu_item)
                @mi_2 = FactoryGirl.create(:menu_item)
                @restaurant = @mi_1.restaurant
                @restaurant.menu_items << @mi_2
                @mit_1 = FactoryGirl.create(:menu_item_tag, menu_item: @mi_1)
                @mit_2 = FactoryGirl.create(:menu_item_tag, menu_item: @mi_1)
                @mit_3 = FactoryGirl.create(:menu_item_tag, menu_item: @mi_2)
            end

            it 'return body the name of the restaurant and an empty menu_items' do
              get "/api/restaurants/#{@restaurant.id}/menu_items?api_key=#{api_key.guid}"
              expected_response = {'restaurant' => @restaurant.name, "menu_items" => []}

              @restaurant.menu_items.each do |menu_item|
                expected_response['menu_items'] << {
                                                      'id' => menu_item.id,
                                                      'name' => menu_item.name,
                                                      'description' => menu_item.description,
                                                      'menu_category' => menu_item.menu_category,
                                                      'tags' => menu_item.tags.pluck(:name)
                                                    }
              end


              expect(response).to have_http_status(200)
              expect(JSON.parse(response.body)).to eq expected_response
            end
          end
        end
      end
    end
  end
end

