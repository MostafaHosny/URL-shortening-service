require 'rails_helper'

RSpec.describe ShortenUrlService do
  describe '#call' do
    subject(:service) { described_class.new(original_url: original_url) }
    let(:original_url) { 'https://example.com' }

    context 'when generating a unique short_id' do
      it 'creates a new ShortenedUrl and returns the shortened URL' do
        expect { service.call }.to change(ShortenedUrl, :count).by(1)
      end
    end

    context 'when a generated short_id already exists' do
      let(:existing_short_id) { 'duplicateId' }
      let(:new_unique_id) { 'uniqueId123' }

      before do
        create(:shortened_url, short_id: existing_short_id)
        allow(Nanoid).to receive(:generate).and_return(existing_short_id, new_unique_id)
      end

      it 'retries and generates a new unique short_id' do
        expect { service.call }.to change(ShortenedUrl, :count).by(1)
        expect(service.short_id).to eq(new_unique_id)
      end
    end

    context 'when unable to generate a unique short_id after max attempts' do
      let(:duplicate_id) { 'duplicateId' }

      before do
        create(:shortened_url, short_id: duplicate_id)
        allow(Nanoid).to receive(:generate).and_return(duplicate_id)
      end

      it 'raises an error after reaching the maximum number of attempts' do
        expect { service.call }.to raise_error(Mongoid::Errors::Validations)
      end
    end
  end
end
