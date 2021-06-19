# frozen_string_literal: true

module AcnhBot
  module Locales
    def en
      days = "monday!tuesday!wednesday!thursday!friday!saturday!sunday".split("!")
      short_days = "mon!tue!wed!thurs!fri!sat!sun".split("!")
      months = "january!february!march!april!may!june!july!august!september!october!november!december".split("!")
      short_months = "jan!feb!march!apr!may!june!july!aug!sept!oct!nov!dec".split("!")
      formats = Hash[
        :long => "DDDD, MMMM DD YYYY at HH:mm",
        :short => "dddd, mmmm DD YYYY à HH:mm",
        :numeric => "MM/DD/YYYY",
        :time => "HH:mm:ms"
      ]
      relative_time = Hash[
        :future => "in &t",
        :past => "&t ago",
        :s => "a few seconds",
        :m => "a minute",
        :mm => "&mm minutes",
        :h => "a hour",
        :hh => "&hh hours",
        :d => "a day",
        :dd => "&jj days",
        :M => "a month",
        :MM => "&MM months",
        :y => "a year",
        :yy => "&yy years"
      ]

      {
        :days => days,
        :short_days => short_days,
        :months => months,
        :short_months => short_months,
        :formats => formats,
        :ordinal => lambda do |n|
          "#{n}st" if n == 1
          "#{n}nd" if n == 2
          "#{n}rd" if n == 3
          "#{n}th" if n > 3
        end,
        :relative_time => relative_time
      }
    end
    module_function :en
  end
end
