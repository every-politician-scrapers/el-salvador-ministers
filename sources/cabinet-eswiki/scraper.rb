#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath("//table[.//th[contains(.,'Periodo')]][1]//tr[td]")
    end
  end

  class Member
    field :id do
      name_node.attr('wikidata')
    end

    field :name do
      name_node.text.tidy
    end

    field :positionID do
    end

    field :position do
      tds[0].text.tidy
    end

    field :startDate do
      WikipediaDate::Spanish.new(dates[0]).to_s
    end

    field :endDate do
      WikipediaDate::Spanish.new(dates[1]).to_s
    end

    private

    def tds
      noko.css('td')
    end

    def name_node
      tds[1]
    end

    def dates
      tds[2].text.split(/[—–-]/).map(&:tidy)
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
