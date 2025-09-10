# == Schema Information
#
# Table name: StatusBarraca
#
#  Id     :integer          not null, primary key
#  Status :string(50)       not null
#
FactoryBot.define do
  factory :status_barraca do
    sequence(:Id) { |n| n }
    Status { 'Ativo' }
  end
end
