require 'rails_helper'

RSpec.describe Snappea::API, type: :request do

  context "GET /api/restaurants?api_key=..." do
    before :each do
      @RESTAURANT_PAGINATION_SIZE = 4
    end

    context 'request was unauthorized because', checked: true do
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
      context 'but no restaurants exist', checked: true do
        let!(:api_key){ FactoryGirl.create(:api_key) }
        before :each do
          Restaurant.delete_all
        end

        it 'return body is an empty set', checked: true do
          get "/api/restaurants?api_key=#{api_key.guid}"

          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq ({})
        end
      end

      context 'and restaurants exist', checked: true do
        context 'but invalid pagination param given because', checked: true do
          context 'page param # > last page #', checked: true do
            let!(:api_key){ FactoryGirl.create(:api_key) }

            before :each do
              @remainder_size = 1
              (@RESTAURANT_PAGINATION_SIZE + @remainder_size).times { FactoryGirl.create(:restaurant) }
            end

            it "returns a the last pagination page of restaurants" do
              get "/api/restaurants?page=65&api_key=#{api_key.guid}"
              restaurants_arr = Restaurant.order(:id).limit(@remainder_size).offset(@RESTAURANT_PAGINATION_SIZE).map do |r|
                json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
                json['rating'] = r.rating.to_s
                json
              end

              expect(response).to have_http_status(200)
              expect(restaurants_arr.length).to eq @remainder_size
              expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'prev' => 'prev_url_here'})
            end
          end

          context 'page param is a non-integer', checked: true do
            let!(:api_key){ FactoryGirl.create(:api_key) }

            before :each do
              @remainder_size = 1
              (@RESTAURANT_PAGINATION_SIZE + @remainder_size).times { FactoryGirl.create(:restaurant) }
            end

            it "returns the last pagination page of restaurants" do
              get "/api/restaurants?api_key=#{api_key.guid}&page=g"

              expect(response).to have_http_status(400)
              expect(JSON.parse(response.body)).to eq({"error"=>"page is invalid"})
            end
          end
        end

        context 'with no pagination page param', checked: true do
          let!(:api_key){ FactoryGirl.create(:api_key) }

          before :each do
            @remainder_size = 1
            (@RESTAURANT_PAGINATION_SIZE + @remainder_size).times { FactoryGirl.create(:restaurant) }
          end

          it "returns the first pagination page of restaurants" do
            get "/api/restaurants?api_key=#{api_key.guid}"

            restaurants_arr = Restaurant.order(:id).limit(@RESTAURANT_PAGINATION_SIZE).map do |r|
              json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
              json['rating'] = r.rating.to_s
              json
            end

            expect(response).to have_http_status(200)
            expect(restaurants_arr.length).to eq @RESTAURANT_PAGINATION_SIZE
            expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'next' => 'next_url_here'})
          end
        end

        context 'with page=1 pagination page param', checked: true do
          let!(:api_key){ FactoryGirl.create(:api_key) }

          before :each do
            @remainder_size = 1
            (@RESTAURANT_PAGINATION_SIZE + @remainder_size).times { FactoryGirl.create(:restaurant) }
          end

          it "returns the first pagination page of restaurants" do
            get "/api/restaurants?api_key=#{api_key.guid}&page=1"

            restaurants_arr = Restaurant.order(:id).limit(@RESTAURANT_PAGINATION_SIZE).map do |r|
              json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
              json['rating'] = r.rating.to_s
              json
            end

            expect(response).to have_http_status(200)
            expect(restaurants_arr.length).to eq @RESTAURANT_PAGINATION_SIZE
            expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'next' => 'next_url_here'})
          end
        end

        context 'with a mid range pagination page param', checked: true do
          let!(:api_key){ FactoryGirl.create(:api_key) }

          before :each do
            @remainder_size = 1
            (2 * @RESTAURANT_PAGINATION_SIZE + @remainder_size).times { FactoryGirl.create(:restaurant) }
          end

          it "returns the first pagination page of restaurants" do
            get "/api/restaurants?api_key=#{api_key.guid}&page=2"

            restaurants_arr = Restaurant.order(:id).offset(@RESTAURANT_PAGINATION_SIZE).limit(@RESTAURANT_PAGINATION_SIZE).map do |r|
              json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
              json['rating'] = r.rating.to_s
              json
            end

            expect(response).to have_http_status(200)
            expect(restaurants_arr.length).to eq @RESTAURANT_PAGINATION_SIZE
            expect(JSON.parse(response.body)).to eq ({'restaurants' => restaurants_arr, 'prev' => 'prev_url_here', 'next' => 'next_url_here'})
          end
        end

        context 'with a end range pagination page param', checked: true do
          let!(:api_key){ FactoryGirl.create(:api_key) }

          before :each do
            @remainder_size = 1
            (@RESTAURANT_PAGINATION_SIZE + @remainder_size).times { FactoryGirl.create(:restaurant) }
          end

          it "returns the first pagination page of restaurants" do
            get "/api/restaurants?api_key=#{api_key.guid}&page=3"

            restaurants_arr = Restaurant.order(:id).offset(@RESTAURANT_PAGINATION_SIZE).limit(@RESTAURANT_PAGINATION_SIZE).map do |r|
              json = JSON.parse(r.to_json).slice('id' , 'name', 'description', 'rating', 'address')
              json['rating'] = r.rating.to_s
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

