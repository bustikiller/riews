FactoryGirl.define do
  factory :column, class: Riews::Column do
    view
    factory :method_column do
      add_attribute(:method) { 'id' }
    end
  end
end
