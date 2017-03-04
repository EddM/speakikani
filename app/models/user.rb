# frozen_string_literal: true

class User
  def initialize(wanikani_api_key)
    @wanikani = Wanikani.new(wanikani_api_key)
    @current_level = user_information["level"]
  end

  def vocab_list
    words = @wanikani.get("/vocabulary/#{@current_level || 1}")["requested_information"]
    words.collect { |word| word["character"] }
  end

  private

  def user_information
    @user_information ||= @wanikani.get("/user-information")["user_information"]
  end
end
