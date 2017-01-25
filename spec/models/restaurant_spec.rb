require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:restaurant)).to be_valid
  end

  context 'model has correct validations' do
    it { is_expected.to validate_presence_of :name}
    it { is_expected.to validate_presence_of :address}

    context 'rating_validation' do
      context 'valid results' do
        it '0.0 is valid' do
          expect(FactoryGirl.build(:restaurant, rating: 0.0)).to be_valid
        end
        it '5.0 is valid' do
          expect(FactoryGirl.build(:restaurant, rating: 5.0)).to be_valid
        end
        it '1 is valid' do
          restaurant = FactoryGirl.build(:restaurant, rating: 1)
          expect(restaurant.rating).to eq 1.0
        end
      end

      context 'invalid results' do
        it '2.22 is invalid' do
          expect(FactoryGirl.build(:restaurant, rating: 2.22)).to_not be_valid
        end
        it '-1 is invalid' do
          expect(FactoryGirl.build(:restaurant, rating: -1)).to_not be_valid
        end
        it '5.1 is invalid' do
          expect(FactoryGirl.build(:restaurant, rating: 5.1)).to_not be_valid
        end
      end
    end
  end
end
