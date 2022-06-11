#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# Only compare IDs, not names, as those differ between WP/WD
class Comparison < EveryPoliticianScraper::NulllessComparison
  def external_csv_options
    { converters: [->(v) { v.to_s.gsub('Ministerio', 'Ministro') }] }
  end
end

diff = Comparison.new('data/wikidata-eswiki.csv', 'data/wikipedia.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
