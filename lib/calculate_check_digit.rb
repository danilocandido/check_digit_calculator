# frozen_string_literal: true

class CalculateCheckDigit
  WEIGHTS = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2].freeze
  MAP_DIGITS = %w[0 1 2 3 4 5 6 7 9 10 X].freeze
  CHECK_DIGIT_INDEX = 8

  def self.[](vin)
    new(String(vin)).display
  end

  def display
    %(
      Provided VIN: %<vin>s
      Check Digit: %<result>s
      %<message>s
    ) % response
  end

  private

  attr_reader :vin

  def initialize(vin)
    @vin = vin.strip
  end

  def response
    {
      vin: vin,
      result: result,
      message: message,
      check_digit: check_digit
    }
  end

  def check_digit
    raise CheckDigitInvalid if invalid_size?

    vin
      .chars
      .each_with_index
      .reduce(0) { |acc, (char, i)| acc + transliterate(char) * WEIGHTS[i] }
      .yield_self { |sum| MAP_DIGITS[sum % 11] }
  rescue StandardError, CheckDigitInvalid
    nil
  end

  def transliterate(char)
    '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'.index(char) % 10
  end

  def valid?
    vin[CHECK_DIGIT_INDEX] == check_digit
  end

  def invalid_size?
    return if vin.empty?

    vin.size != 17
  end

  def result
    valid? ? :VALID : :INVALID
  end

  def message
    case result
    when :VALID then "This looks like a VALID vin! #{check_digit}"
    when :INVALID
      %(
        Suggested VIN(s):
          - Check digit #{vin[CHECK_DIGIT_INDEX]} is incorrect, correct value is #{check_digit}
      )
    end
  end

  class CheckDigitInvalid < StandardError; end
end
