# frozen_string_literal: true

RSpec.describe AddReadingService, '#call' do
  context 'when get endpoint and ip' do
    it 'Add into endpont_with_api_collection' do
      subject.call(endpoint: endpoint, ip: ip)

      expect(endpont_with_api_collection.not_exist?(endpoint, ip)).to eq false
    end
  end

  context 'when get endpoint and ip' do
    it 'Add into endpont_with_api_collection' do
      subject.call(endpoint: endpoint, ip: ip)

      expect(endpont_with_api_collection.not_exist?(endpoint, ip)).to eq false
    end
  end

  context 'when get endpoint and ip' do
    it 'Add into endpont_with_api_collection' do
      subject.call(endpoint: endpoint, ip: ip)

      expect(endpont_with_api_collection.not_exist?(endpoint, ip)).to eq false
    end
  end

  context 'when get endpoint and ip' do
    it 'Add into endpont_with_api_collection' do
      subject.call(endpoint: endpoint, ip: ip)

      expect(endpont_with_api_collection.not_exist?(endpoint, ip)).to eq false
    end
  end

  context 'when get endpoint and ip' do
    it 'Add into endpont_with_api_collection' do
      subject.call(endpoint: endpoint, ip: ip)

      expect(endpont_with_api_collection.not_exist?(endpoint, ip)).to eq false
    end
  end
end
