
FactoryGirl.define do
  factory :audio, :class => Refinery::Audios::Audio do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

