# frozen_string_literal: true

class SentenceSynthesisJob < ApplicationJob
  queue_as :default

  def perform(sentence, speed)
    sentence.synthesize(speed)
  end
end
