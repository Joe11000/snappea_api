require 'rails_helper'

RSpec.describe Snappea::API, type: :request do

  context "GET /api/restaurants?api_key=..." do
    context 'request was unauthorized because' do
      it 'no api_key param was given and returned a 400 error json' do
        get "/api/restaurants"

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq ({"error"=>"api_key is missing"})
      end

      it 'the api_key was invalid and returned a 401 error json' do
        get "/api/restaurants?api_key=132"

        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)).to eq ({"error"=>"401 Unauthorized"})
      end
    end

    context 'request has an authorized api_key' do
      context 'but no restaurants exist' do
        let!(:api_key){ FactoryGirl.create(:api_key) }
        before :each do
          Restaurant.delete_all
        end

        it 'return body is an empty set' do
          get "/api/restaurants?api_key=#{api_key.guid}"

          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq ({})
        end
      end

      context 'and restaurants exist' do
        context 'but invalid pagination param given because' do
          context 'page param # > last page #' do
            let!(:api_key){ FactoryGirl.create(:api_key) }

            before :each do
              @remainder_size = 1

              (ENV['RESTAURANT_PAGINATION_SIZE'].to_i + @remainder_size).times { FactoryGirl.create(:restaurant) }
            end

            it "returns a the last pagination page of restaurants" do
              get "/api/restaurants?page=65&api_key=#{api_key.guid}"

              restaurants_arr = Restaurant.order(:id).limit(@remainder_size).offset(ENV['RESTAURANT_PAGINATION_SIZE'].to_i).map do |r|
                json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
                json['rating'] = r.rating
                json
              end

              expect(response).to have_http_status(200)
              expect(restaurants_arr.length).to eq @remainder_size
              expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'prev' => 'prev_url_here'})
            end
          end

          context 'page param is a non-integer' do
            let!(:api_key){ FactoryGirl.create(:api_key) }

            before :each do
              @remainder_size = 1
              (ENV['RESTAURANT_PAGINATION_SIZE'].to_i + @remainder_size).times { FactoryGirl.create(:restaurant) }
            end

            it "returns the last pagination page of restaurants" do
              get "/api/restaurants?api_key=#{api_key.guid}&page=g"

              expect(response).to have_http_status(400)
              expect(JSON.parse(response.body)).to eq({"error"=>"page is invalid"})
            end
          end
        end

        context 'with no pagination page param' do
          let!(:api_key){ FactoryGirl.create(:api_key) }

          before :each do
            @remainder_size = 1
            (ENV['RESTAURANT_PAGINATION_SIZE'].to_i + @remainder_size).times { FactoryGirl.create(:restaurant) }
          end

          it "returns the first pagination page of restaurants" do
            get "/api/restaurants?api_key=#{api_key.guid}"

            restaurants_arr = Restaurant.order(:id).limit(ENV['RESTAURANT_PAGINATION_SIZE'].to_i).map do |r|
              json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
              json['rating'] = r.rating
              json
            end

            expect(response).to have_http_status(200)
            expect(restaurants_arr.length).to eq ENV['RESTAURANT_PAGINATION_SIZE'].to_i
            expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'next' => 'next_url_here'})
          end
        end

        context 'with page=1 pagination page param' do
          let!(:api_key){ FactoryGirl.create(:api_key) }

          before :each do
            @remainder_size = 1
            (ENV['RESTAURANT_PAGINATION_SIZE'].to_i + @remainder_size).times { FactoryGirl.create(:restaurant) }
          end

          it "returns the first pagination page of restaurants" do
            get "/api/restaurants?api_key=#{api_key.guid}&page=1"

            restaurants_arr = Restaurant.order(:id).limit(ENV['RESTAURANT_PAGINATION_SIZE'].to_i).map do |r|
              json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
              json['rating'] = r.rating
              json
            end

            expect(response).to have_http_status(200)
            expect(restaurants_arr.length).to eq ENV['RESTAURANT_PAGINATION_SIZE'].to_i
            expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'next' => 'next_url_here'})
          end
        end

        context 'with a mid range pagination page param' do
          let!(:api_key){ FactoryGirl.create(:api_key) }

          before :each do
            @remainder_size = 1
            (2 * ENV['RESTAURANT_PAGINATION_SIZE'].to_i + @remainder_size).times { FactoryGirl.create(:restaurant) }
          end

          it "returns the first pagination page of restaurants" do
            get "/api/restaurants?api_key=#{api_key.guid}&page=2"

            restaurants_arr = Restaurant.order(:id).offset(ENV['RESTAURANT_PAGINATION_SIZE'].to_i).limit(ENV['RESTAURANT_PAGINATION_SIZE'].to_i).map do |r|
              json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
              json['rating'] = r.rating
              json
            end

            expect(response).to have_http_status(200)
            expect(restaurants_arr.length).to eq ENV['RESTAURANT_PAGINATION_SIZE'].to_i
            expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'prev' => 'prev_url_here', 'next' => 'next_url_here'})
          end
        end

        context 'with a end range pagination page param' do
          let!(:api_key){ FactoryGirl.create(:api_key) }

          before :each do
            @remainder_size = 1
            (ENV['RESTAURANT_PAGINATION_SIZE'].to_i + @remainder_size).times { FactoryGirl.create(:restaurant) }
          end

          it "returns the first pagination page of restaurants" do
            get "/api/restaurants?api_key=#{api_key.guid}&page=3"

            restaurants_arr = Restaurant.order(:id).offset(ENV['RESTAURANT_PAGINATION_SIZE'].to_i).limit(ENV['RESTAURANT_PAGINATION_SIZE'].to_i).map do |r|
              json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
              json['rating'] = r.rating
              json
            end

            expect(response).to have_http_status(200)
            expect(restaurants_arr.length).to eq @remainder_size
            expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'prev' => 'prev_url_here' })
          end
        end
      end
    end
  end
end

