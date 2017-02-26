# frozen_string_literal: true

class SentenceStatusChannel < ApplicationCable::Channel
  def subscribed
    @sentence = Sentence.find(params[:id])
    stream_for @sentence
  end
end
