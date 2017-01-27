require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:menu_item)).to be_valid
  end

  context 'model has correct validations' do
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to have_many :menu_item_tags }
    it { is_expected.to have_many(:tags).through(:menu_item_tags) }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :menu_category }
    it { is_expected.to validate_inclusion_of(:menu_category).in_array(%w(Entree Appetizer Dessert Beverage Side)) }
  end
end
