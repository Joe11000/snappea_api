require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:api_key)).to be_valid
  end

  context 'model has correct validations' do
    it { is_expected.to validate_presence_of :guid }
    it { is_expected.to validate_length_of(:guid).is_equal_to(32) }
    it { is_expected.to validate_uniqueness_of :guid }
  end
end
