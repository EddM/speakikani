# frozen_string_literal: true

class SentenceSynthesisService < ServiceObject
  SPEEDS = ["medium", "slow"].freeze
  BUCKET_NAME = "speakikani"

  attr_reader :speed, :sentence

  def initialize(sentence, speed = SPEEDS.first)
    @sentence = sentence
    @speed = speed
  end

  def perform
    # Bail if the sentence object in question already has a filename
    # for this speed setting
    attribute_name = :"#{speed}_filename"
    return if sentence.send attribute_name

    # Synthesize an audio file with the given japanese phrase
    filename = synthesize

    # Send it to Amazon S3
    public_url = ship_to_s3(filename)

    # Update the sentence object with the public URL for the file on S3
    sentence.update_attributes attribute_name => public_url
    SentenceStatusChannel.broadcast_to(sentence, sentence.as_json)
  end

  private

  def synthesize
    raise "Unknown speed #{speed}" unless SPEEDS.include?(speed)

    filename = "#{Rails.root}/tmp/#{@sentence.identifier}_#{@speed}.mp3"
    polly_client.synthesize_speech response_target: filename,
                                   text: generate_ssml(@sentence.japanese, @speed),
                                   text_type: "ssml",
                                   output_format: "mp3",
                                   voice_id: "Mizuki"

    filename
  end

  def ship_to_s3(filename)
    create_bucket
    object_name = "sentences/#{@speed}/#{@sentence.identifier}.mp3"

    # upload it
    s3_client.put_object bucket: BUCKET_NAME,
                         key: object_name,
                         body: File.open(filename, "rb").read,
                         acl: "public-read"

    # build its url
    "https://#{BUCKET_NAME}.s3.amazonaws.com/#{object_name}"
  end

  def create_bucket
    buckets = s3_client.list_buckets
    return if buckets.include? BUCKET_NAME

    s3_client.create_bucket bucket: BUCKET_NAME
  end

  def generate_ssml(text, speed)
    "<speak>" \
      "<prosody rate=\"#{speed}\">#{text}</prosody>" \
    "</speak>"
  end

  def polly_client
    @polly_client ||= Aws::Polly::Client.new
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(region: "us-east-1")
  end
end
