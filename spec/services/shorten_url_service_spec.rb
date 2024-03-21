require 'rails_helper'

RSpec.describe ShortenUrlService do
  describe '#call' do
    let(:original_url) { 'https://example.com' }
    let(:service) { described_class.new(original_url: original_url) }
    let(:max_attempts) { ShortenUrlService::MAX_ATTEMPTS }
    
    context 'when a unique short_id is generated on the first try' do
      it 'creates a new ShortenedUrl record' do
        expect { service.call }.to change { ShortenedUrl.count }.by(1)
      end
    end

    context 'when a collision occurs' do
      let!(:existing_shortened_url) { create(:shortened_url, short_id: 'existingid') }
      
      context 'When it happens only once' do
        before do
          allow(Nanoid).to receive(:generate).and_return('existingid', 'uniqueid')
        end

        it 'retries and creates a new ShortenedUrl with a unique short_id' do
          expect { service.call }.to change { ShortenedUrl.count }.by(1)
          expect(ShortenedUrl.last.short_id).not_to eq(existing_shortened_url.short_id)
        end
      end

      context "when collisions occur for MAX_ATTEMPTS attempts" do
        before do
          allow(Nanoid).to receive(:generate).and_return('existingid')
        end
  
        it "raises an error after max_attempts" do
          expect(Nanoid).to receive(:generate).exactly(max_attempts + 1).times
          expect { service.call }.to raise_error(RuntimeError, /Unable to create a unique short URL after #{max_attempts} attempts/)
        end
      end
    end
  end
end
