# frozen_string_literal: true

class SentencesController < ApplicationController
  def index
    @sentences = Sentence.order("RANDOM()").limit(10)
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
    params[:speed] || "slow"
  end
end
