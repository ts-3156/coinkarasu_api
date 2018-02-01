FactoryBot.define do
  factory :app do
    sequence(:uuid) {|n| "#{'u' * 20}#{n}"}
    sequence(:key) {|n| "#{'k' * 20}#{n}"}
    sequence(:secret) {|n| "#{'s' * 20}#{n}"}
  end
end
