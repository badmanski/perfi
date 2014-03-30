require 'spec_helper'

describe Period do
  describe 'Shortenings' do
    let(:period) { Period.make! }

    it 'return period type' do
      expect(period.type).to be period.period_type
    end
  end

  describe 'Set default values' do
    let(:type) { PeriodType.make!(name: 'Month') }
    let(:period) { Period.make(period_type: type) }

    it 'sets start_date' do
      period.set_start_date
      expect(period.start_date).to eq Date.today.beginning_of_month
    end

    it 'sets end_date' do
      period.set_end_date
      expect(period.end_date).to eq Date.today.end_of_month
    end

    it 'sets name' do
      period.set_start_date
      period.set_end_date
      period.set_name
      expect(period.name)
        .to eq "#{I18n.l(period.start_date)} - #{I18n.l(period.end_date)}"
    end

    it 'sets attributes before validation' do
      period.set_attrs
      expect(period.start_date).not_to be nil
      expect(period.end_date).not_to be nil
      expect(period.name).not_to be nil
    end
  end
end
