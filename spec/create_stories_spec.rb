RSpec::Matchers.define :a_valid_row_data do |data|
  match { |actual| actual.to_h == data }
end

describe Ehpt::CreateStories do
  let(:project) { double }
  let(:service) { described_class.new(csv_content, project) }
  let(:csv_content) {
    "name,estimate\r\n"\
    "Add API,3"
  }

  context 'csv content is invalid' do
    let(:csv_content) { nil }

    it 'errors is present' do
      service.call
      expect(service.errors).to eq(['CSV content is empty'])
    end
  end

  context 'create story successfully' do
    let(:story_creator) { double('Ehpt::CreateStory', call: nil, error?: false) }

    it 'calls Ehpt::CreateStory with correct params' do
      expect(Ehpt::CreateStory).to receive(:new).with(
        project,
        a_valid_row_data({"name"=>"Add API", "estimate"=>3.0})
      ).and_return(story_creator)
      expect(story_creator).to receive(:call)

      service.call
    end

    it 'errors is empty' do
      allow_any_instance_of(Ehpt::CreateStory).to receive(:call)

      service.call

      expect(service.errors).to eq([])
    end
  end

  context 'there are stories that created failed' do
    let(:story_creator) do
      double('Ehpt::CreateStory', call: nil, error?: true, errors: ['Error'])
    end

    it 'errors is present' do
      expect(Ehpt::CreateStory).to receive(:new).with(
        project,
        a_valid_row_data({"name"=>"Add API", "estimate"=>3.0})
      ).and_return(story_creator)

      service.call

      expect(service.errors).to eq(['Error'])
    end
  end
end
