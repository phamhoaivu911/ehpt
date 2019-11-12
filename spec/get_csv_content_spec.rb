describe Ehpt::GetCsvContent do
  let(:service) { described_class.new(file) }

  context '.csv file extension' do
    let(:file_content) { 'File Content' }
    let(:file) { 'path/to/file.csv' }

    it 'calls File.read to read data' do
      expect(File).to receive(:read).with(file).and_return(file_content)

      service.call

      expect(service.success?).to eq(true)
      expect(service.data).to eq(file_content)
    end
  end

  context 'NOT .csv file extension' do
    let(:file) { 'path/to/file.rb' }

    it 'it returns error' do
      expect(File).not_to receive(:read)

      service.call

      expect(service.success?).to eq(false)
      expect(service.data).to eq(nil)
    end
  end
end
