RSpec::Matchers.define :a_valid_row_data do |data|
  match { |actual| actual.to_h == data }
end

describe Ehpt::CreateStories do
  let(:project) { double }
  let(:service) { described_class.new(csv_file, project) }

  context 'not a csv file' do
    let(:csv_file) { File.join(File.dirname(__FILE__), './test_data/sample.rb') }

    it 'errors is present' do
      service.call
      expect(service.errors).to eq(['Input file must be a csv file'])
    end
  end

  context 'file is empty' do
    let(:csv_file) { File.join(File.dirname(__FILE__), './test_data/empty.csv') }

    it 'errors is present' do
      service.call
      expect(service.errors).to eq(['CSV content is empty'])
    end
  end

  context 'valid csv file' do
    let(:csv_file) { File.join(File.dirname(__FILE__), './test_data/sample.csv') }

    context 'create story successfully' do
      let(:story_creator) do
        double('Ehpt::CreateStory', call: nil, success?: true, data: OpenStruct.new(name: 'Story'))
      end

      before do
        expect(Ehpt::CreateStory).to receive(:new).with(
          project,
          a_valid_row_data({"name"=>"Add API", "estimate"=>3.0})
        ).and_return(story_creator)
      end

      it 'calls Ehpt::CreateStory' do
        expect(story_creator).to receive(:call)
        service.call
      end

      it 'errors is empty' do
        service.call
        expect(service.errors).to eq([])
      end
    end

    context 'there are stories that created failed' do
      let(:story_creator) do
        double('Ehpt::CreateStory', call: nil, success?: false, errors: ['Error'])
      end

      it 'errors is present' do
        expect(Ehpt::CreateStory).to receive(:new).with(
          project,
          a_valid_row_data({"name"=>"Add API", "estimate"=>3.0})
        ).and_return(story_creator)

        service.call

        expect(service.errors).to eq([{ row: {"name"=>"Add API", "estimate"=>"3"}, errors: ['Error'] }])
      end
    end
  end
end
