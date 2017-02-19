# frozen_string_literal: true

FactoryGirl.define do
  factory :sentence do
    sequence(:japanese) { |n| "こんにちは、#{n}。" }
    english "hello"
  end
end
