FactoryBot.define do
  factory :cryptocompare_price_multi_full, class: 'Cryptocompare::PriceMultiFull' do
    from_symbol "MyString"
    to_symbol "MyString"
    data ""
  end
end
