# frozen_string_literal: true

# !/usr/bin/env ruby

require 'pry'

vin = ARGV[0]

class CalculateCheckDigit
  def self.[](vin)
    new(vin).response
  end

  def response
    <<~TXT
      Provided VIN: #{vin}
      Check Digit: #{check_digit} #{result}
      #{message}
    TXT
  end

  private

  attr_reader :vin

  def initialize(vin)
    @vin = vin
  end

  def check_digit
    vin
      .chars
      .each_with_index
      .reduce(0) { |acc, (char, i)| acc + transliterate(char) * weights[i] }
      .yield_self { |sum| map[sum % 11] }
  rescue StandardError
    nil
  end

  def transliterate(char)
    '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'.index(char) % 10
  end

  def map
    [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 'X']
  end

  def weights
    [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2]
  end

  def message
    {
      VALID: 'This looks like a VALID vin!',
      INVALID: 'Suggested VIN(s):'
    }[result]
  end

  def result
    check_digit ? :VALID : :INVALID
  end
end

chk_digit = CalculateCheckDigit[vin]
puts chk_digit