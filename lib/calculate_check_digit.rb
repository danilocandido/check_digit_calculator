# frozen_string_literal: true

# !/usr/bin/env ruby

require 'pry'

vin = ARGV[0]

class CalculateCheckDigit
  def self.[](vin)
    new[vin]
  end

  def [](vin)
    sum = vin.chars.each_with_index.reduce(0) do |acc, (char, i)|
      acc + transliterate(char) * weights[i]
    end

    map[sum % 11]
  end

  private

  def transliterate(char)
    '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'.index(char) % 10
  end

  def map
    [*(0..10), 'X']
  end

  def weights
    [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2]
  end
end

chk_digit = CalculateCheckDigit[vin]
puts chk_digit