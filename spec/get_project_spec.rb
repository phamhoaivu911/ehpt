describe Ehpt::GetProject do
  let(:client) { double('PT Client', project: double) }

  context 'token and project_id are not provided' do
    before do
      ENV['PIVOTAL_TRACKER_TOKEN'] = 'token_from_env'
      ENV['PIVOTAL_TRACKER_PROJECT_ID'] = 'project_id_from_env'
    end

    after do
      ENV['PIVOTAL_TRACKER_TOKEN'] = nil
      ENV['PIVOTAL_TRACKER_PROJECT_ID'] = nil
    end

    it 'calls TrackerApi::Client with token and project_id from ENV' do
      expect(TrackerApi::Client).to receive(:new).with(
        token: 'token_from_env'
      ).and_return(client)
      expect(client).to receive(:project).with('project_id_from_env')

      service = described_class.new(nil, nil)
      service.call
    end
  end

  context 'token and project_id are provided' do
    it 'calls TrackerApi::Client with provided token and project_id' do
      expect(TrackerApi::Client).to receive(:new).with(
        token: 'abc123'
      ).and_return(client)
      expect(client).to receive(:project).with('xyz456')

      service = described_class.new('abc123', 'xyz456')
      service.call
    end
  end

  context 'get project error' do
    let(:service) { described_class.new('abc123', 'xyz456') }
    before do
      allow(TrackerApi::Client).to receive(:new).and_raise(StandardError, '{body: "Error"}')
      service.call
    end

    it 'data is nil' do
      expect(service.data).to eq(nil)
    end

    it 'errors is present' do
      expect(service.errors).to eq(['Error'])
    end
  end
end
