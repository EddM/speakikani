# frozen_string_literal: true

require "test_helper"

class SentenceTest < ActiveSupport::TestCase
  test "generates a unique identifier" do
    create(:sentence, identifier: "abc123")
    SecureRandom.stubs(:hex).returns("abc123").then.returns("def567")

    sentence = create(:sentence)

    assert_equal sentence.identifier, "def567"
  end
end
