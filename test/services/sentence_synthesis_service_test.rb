# frozen_string_literal: true

require "test_helper"

class SentenceSynthesisServiceTest < ActiveSupport::TestCase
  def setup
    @sentence = create(:sentence, japanese: "こんにちは", identifier: "lolwtf123")
    VCR.insert_cassette "sentence_synthesis"
  end

  def teardown
    VCR.eject_cassette
  end

  test "generates an mp3 file of the sentence" do
    SentenceSynthesisService.perform(@sentence, :slow)

    assert File.exist?("#{Rails.root}/tmp/lolwtf123_slow.mp3")
  end

  test "sends the file to amazon s3" do
    mock_s3_client = mock
    mock_s3_client.expects(:put_object).once
    mock_s3_client.stubs(:list_buckets).returns(["speakikani"])
    service = SentenceSynthesisService.new(@sentence, :slow)
    service.stubs(:s3_client).returns(mock_s3_client)

    service.perform
  end

  test "updates the record with the url" do
    assert_change -> { @sentence.reload.slow_filename } do
      SentenceSynthesisService.perform(@sentence, :slow)
    end
  end

  test "aborts if the sentence has already been synthesized" do
    @sentence.slow_filename = "foo"
    mock_polly_client = mock
    mock_polly_client.expects(:synthesize_speech).never
    service = SentenceSynthesisService.new(@sentence, :slow)
    service.stubs(:polly_client).returns(mock_polly_client)

    service.perform
  end
end
