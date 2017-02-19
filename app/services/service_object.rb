# frozen_string_literal: true

class ServiceObject
  def self.perform(*args)
    new(*args).perform
  end
end
