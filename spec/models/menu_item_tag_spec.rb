require 'rails_helper'

RSpec.describe MenuItemTag, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:menu_item_tag)).to be_valid
  end

  context 'model has correct validations' do
    it { is_expected.to belong_to :tag }
    it { is_expected.to belong_to :menu_item }
  end
end
