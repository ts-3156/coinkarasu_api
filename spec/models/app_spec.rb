require 'rails_helper'

RSpec.describe App, type: :model do
  it 'should be valid' do
    expect(build(:app)).to be_valid
  end

  it 'should be invalid' do
    attrs = %i(uuid key secret)

    [nil, '', 'a'].product(attrs).each do |str, attr|
      expect(build(:app).tap {|a| a[attr] = str}).to_not be_valid
    end

    attrs.each do |attr|
      app = build(:app).tap(&:save!)
      expect(build(:app).tap {|a| a[attr] = app[attr]}).to_not be_valid
    end
  end

  describe '.generate!' do
    it 'creates a new record' do
      uuid = 'uuid' * 10
      expect {App.generate!(uuid: uuid)}.to change {App.all.size}.by(1)
      expect(App.last.uuid).to eq(uuid)
    end
  end
end
