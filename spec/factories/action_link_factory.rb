FactoryGirl.define do
  factory :action_link, class: Riews::ActionLink do
    sequence(:base_path){ |n| "www.example.com/users/#{n}/edit"}
    sequence(:display_pattern){ |n| "Pattern #{n}"}
  end
end
