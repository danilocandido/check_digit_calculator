# frozen_string_literal: true

require_relative '../lib/calculate_check_digit'

describe CalculateCheckDigit do
  subject { CalculateCheckDigit[vin] }

  context 'valid' do
    let(:vin) { '2NKWL00X16M149834' }

    it { should include('This looks like a VALID vin!') }
  end

  context 'wrong formats' do
    [nil, ''].each do |value|
      let(:vin) { value }
      it { should include('INVALID') }
    end
  end
end
