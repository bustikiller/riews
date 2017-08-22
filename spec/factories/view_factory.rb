FactoryGirl.define do
  factory :view, class: Riews::View do
    sequence(:code){ |n| "view_#{n}" }
    name { code }
  end
end
