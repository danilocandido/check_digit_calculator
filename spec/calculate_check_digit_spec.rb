# frozen_string_literal: true

require_relative '../lib/calculate_check_digit'

describe CalculateCheckDigit do
  subject { CalculateCheckDigit[vin] }

  describe '#response' do
    describe 'valid' do
      let(:vin) { '2NKWL00X16M149834' }

      it { should include('Check Digit: VALID') }
      it { should include('This looks like a VALID vin!') }

      context 'check digit X' do
        let(:vin) { '1M8GDM9AXKP042788' }

        it { should include('Check Digit: VALID') }
      end
    end

    describe 'invalid format' do
      [nil, '', ' '].each do |value|
        let(:vin) { value }
        it { should include('INVALID') }
      end
    end
  end
end
