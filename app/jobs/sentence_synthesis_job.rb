# frozen_string_literal: true

class SentenceSynthesisJob < ApplicationJob
  queue_as :default

  def perform(sentence, speed)
    SentenceSynthesisService.perform(sentence, speed)
  end
end
