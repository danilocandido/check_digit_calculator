# frozen_string_literal: true

# !/usr/bin/env ruby

class CalculateCheckDigit
  CHECK_DIGIT_INDEX = 8

  def self.[](vin)
    new(String(vin)).response
  end

  def response
    <<~TXT
      Provided VIN: #{vin}
      Check Digit: #{result}
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
    %w[0 1 2 3 4 5 6 7 9 10 X]
  end

  def weights
    [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2]
  end

  def valid_check_digit?
    vin[CHECK_DIGIT_INDEX] == check_digit
  end

  def result
    valid_check_digit? ? :VALID : :INVALID
  end

  def message
    case result
    when :VALID
      'This looks like a VALID vin!'
    when :INVALID
      <<~TXT
        Suggested VIN(s):
          - Check digit #{vin[CHECK_DIGIT_INDEX]} is incorrect, correct value is #{check_digit}
      TXT
    end
  end
end
