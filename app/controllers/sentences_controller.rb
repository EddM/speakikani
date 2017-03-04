# frozen_string_literal: true

class SentencesController < ApplicationController
  def index
    @sentences = find_sentences
    @speed = speed_param

    @sentences.select { |s| !s.processed?(@speed) }.each do |sentence|
      SentenceSynthesisJob.perform_later sentence, @speed
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def speed_param
    SentenceSynthesisService::SPEEDS.include?(params[:speed]) ? params[:speed] : "slow"
  end

  def find_sentences
    sentences = Sentence

    if user
      vocab_patterns = user.vocab_list.map { |vocab| "%#{vocab.remove("〜")}%" }
      sentences = sentences.where("#{(["japanese LIKE ?"] * vocab_patterns.size).join(" OR ")}", *vocab_patterns)
    end

    sentences.order("RANDOM()").limit(10)
  end

  def user
    return unless params[:wanikani_api_key]

    User.new(params[:wanikani_api_key])
  end
end
