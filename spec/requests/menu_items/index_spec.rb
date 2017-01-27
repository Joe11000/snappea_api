require 'rails_helper'

RSpec.describe Snappea::API, type: :request do

  context "GET /api/restaurants/:id/menu_items?api_key=...", checked: true do
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
      context 'but no restaurants exist', checked: true do
        let!(:api_key){ FactoryGirl.create(:api_key) }

        it 'return body is an empty set' do
          get "/api/restaurants/4444444/menu_items?api_key=#{api_key.guid}"

          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq ({})
        end
      end

      context 'and restaurants exist' do
        context 'but no menu_items exist', checked: true do
          let!(:api_key){ FactoryGirl.create(:api_key) }
          let(:restaurant) { FactoryGirl.create(:restaurant) }

          it 'return body the name of the restaurant and an empty menu_items' do
            get "/api/restaurants/#{@restaurant.id}/menu_items?api_key=#{api_key.guid}"

            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq ({"restaurant"=> restaurant.name, "menu_items"=>[]})
          end
        end

        context 'and menu_items exist' do
          context 'but no menu_item_tags associations cooresponding to tags exist', checked: true do
            let!(:api_key){ FactoryGirl.create(:api_key) }
            let(:restaurant) { FactoryGirl.create(:restaurant) }

            it 'return body the name of the restaurant and an empty menu_items' do
              get "/api/restaurants/#{restaurant.id}/menu_items?api_key=#{api_key.guid}"

              expect(response).to have_http_status(200)
              expect(JSON.parse(response.body)).to eq ({"restaurant"=> restaurant.name, "menu_items"=>[]})
            end
          end

          context 'menu_item_tags associations cooresponding to tags exist', checked: true do
            it 'return body the name of the restaurant and an empty menu_items' do
              get "/api/restaurants/#{@restaurant.id}/menu_items?api_key=#{api_key.guid}"

              expect(response).to have_http_status(200)
              expect(JSON.parse(response.body)).to eq ({ "restaurant"=> @restaurant.name })
            end
          end
        end
      end
    end
  end
end

