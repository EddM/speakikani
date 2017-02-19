# frozen_string_literal: true

desc "Import sentence data from a file specified in FILENAME"
task import: :environment do
  filename = ENV["FILENAME"]

  # File must be in a simple format: one sentence per line, with the japanese/english translations
  # split by a tab character (\t)
  file = File.open(filename)
  total_lines = `wc -l #{filename}`.strip.split(" ").first.to_i
  progress_bar = ProgressBar.create(title: "Sentences", starting_at: 0, total: total_lines, format: " %t (%c/%C)  %B")

  file.each_line do |line|
    japanese, translation = line.split("\t")
    sentence = Sentence.create(japanese: japanese.strip, english: translation.strip, source: :tanaka)
    progress_bar.increment
  end
end
