describe Ehpt::CreateStory do
  let(:story) do
    double('PT story', name: 'Add API', id: 123456789, 'name=': nil, save: 'story saved')
  end
  let(:project) { double('PT project', create_story: story) }
  let(:story_attrs) { { name: 'Add API', labels: ['backend', 'API'], estimate: 3 } }
  let(:service) { described_class.new(project, story_attrs) }

  context 'create story successfully' do
    it 'calls create_story with correct story_attrs' do
      service.call
      expect(project).to have_received(:create_story).with(story_attrs)
    end

    it 'prefix the newly created story with id' do
      service.call
      expect(story).to have_received('name=').with('789 - Add API')
      expect(story).to have_received(:save)
    end
  end

  context 'create story failed' do
    it 'errors is present' do
      allow(project).to receive(:create_story).and_raise(StandardError, 'Error')
      service.call
      expect(service.errors).to eq(['Error'])
    end
  end
end
