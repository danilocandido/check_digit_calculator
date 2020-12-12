# frozen_string_literal: true

# !/usr/bin/env ruby

require 'pry'

vin = ARGV[0]

class CalculateCheckDigit
  def self.[](vin)
    new[vin]
  end

  def [](vin)
    sum = 0
    map = [*(0..10), 'X']
    weights = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2]

    vin.chars.each_with_index do |char, i|
      sum += transliterate(char) * weights[i]
    end
    map[sum % 11]
  end

  private

  def transliterate(char)
    '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'.index(char) % 10
  end
end

chk_digit = CalculateCheckDigit[vin]
puts chk_digit