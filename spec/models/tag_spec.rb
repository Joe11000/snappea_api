require 'rails_helper'

RSpec.describe Tag, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:tag)).to be_valid
  end

  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to have_many :menu_item_tags }
  it { is_expected.to have_many(:menu_items).through(:menu_item_tags) }
end
