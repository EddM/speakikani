# frozen_string_literal: true

class CreateSentences < ActiveRecord::Migration[5.0]
  def change
    create_table :sentences do |t|
      t.string :japanese
      t.string :english
      t.string :source
      t.string :slow_filename
      t.string :medium_filename
      t.string :identifier
      t.timestamps
    end
  end
end
