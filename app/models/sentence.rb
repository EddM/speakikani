# frozen_string_literal: true

class Sentence < ApplicationRecord
  validates :identifier, presence: true
  validates :japanese, uniqueness: true

  before_validation :set_identifier, unless: -> { identifier.present? }

  scope :unprocessed, ->(speed) { where(:"#{speed}_filename" => nil) }

  def processed?(speed)
    filename(speed).present?
  end

  def filename(speed)
    attributes["#{speed}_filename"].presence
  end

  private

  def set_identifier
    candidate = generate_identifier

    while Sentence.where(identifier: candidate).any?
      candidate = generate_identifier
    end

    self.identifier = candidate
  end

  def generate_identifier
    SecureRandom.hex(16)
  end
end
