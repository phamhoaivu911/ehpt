describe Ehpt::CreateStoryAttributes do
  let(:base_row) do
    {
      'name' => 'Add API',
      'description' => 'Add API to get list of users',
      'story_type' => 'feature',
      'labels' => 'web,sprint 1',
      'follower_ids' => '1,2,3',
      'project_id' => '100',
      'estimate' => '3',
      'label_ids' => nil
    }
  end
  let(:service) { described_class.new(row) }

  context 'there is owners attr' do
    let(:row) { base_row.merge('owners' => 'VP, Foo') }

    context 'found user with the initial' do
      let(:user_id_getter1) do
        double('Ehpt::GetUserIdFromInitial', call: nil, error?: false, data: 69)
      end
      let(:user_id_getter2) do
        double('Ehpt::GetUserIdFromInitial', call: nil, error?: true, errors: ['Not found Foo'])
      end

      before do
        expect(Ehpt::GetUserIdFromInitial).to receive(:new).with('VP').and_return(user_id_getter1)
        expect(Ehpt::GetUserIdFromInitial).to receive(:new).with('Foo').and_return(user_id_getter2)
        expect(user_id_getter1).to receive(:call)
        expect(user_id_getter2).to receive(:call)
      end

      it 'returns attrs with owners' do
        service.call

        expect(service.data).to eq({
          'name' => 'Add API',
          'description' => 'Add API to get list of users',
          'labels' => ['web', 'sprint 1'],
          'follower_ids' => [1, 2, 3],
          'project_id' => 100,
          'estimate' => 3.0,
          'story_type' => 'feature',
          'owner_ids'  => [69]
        })
      end
    end

    context 'NOT found user with the initial' do
      let(:user_id_getter1) do
        double('Ehpt::GetUserIdFromInitial', call: nil, error?: true, errors: ['Not found VP'])
      end
      let(:user_id_getter2) do
        double('Ehpt::GetUserIdFromInitial', call: nil, error?: true, errors: ['Not found Foo'])
      end

      before do
        expect(Ehpt::GetUserIdFromInitial).to receive(:new).with('VP').and_return(user_id_getter1)
        expect(Ehpt::GetUserIdFromInitial).to receive(:new).with('Foo').and_return(user_id_getter2)
        expect(user_id_getter1).to receive(:call)
        expect(user_id_getter2).to receive(:call)
      end

      it 'returns attrs without owners' do
        service.call

        expect(service.data).to eq({
          'name' => 'Add API',
          'description' => 'Add API to get list of users',
          'labels' => ['web', 'sprint 1'],
          'follower_ids' => [1, 2, 3],
          'project_id' => 100,
          'estimate' => 3.0,
          'story_type' => 'feature',
        })
      end

      it 'has warnings' do
        service.call

        expect(service.warnings).to eq([
          { row: row, warnings: ['Not found VP'] },
          { row: row, warnings: ['Not found Foo'] }
        ])
      end
    end
  end

  context 'there is requested_by attr' do
    let(:row) { base_row.merge('requested_by' => 'VP') }

    context 'found user with the initial' do
      let(:user_id_getter) do
        double('Ehpt::GetUserIdFromInitial', call: nil, error?: false, data: 69)
      end

      before do
        expect(Ehpt::GetUserIdFromInitial).to receive(:new).with('VP').and_return(user_id_getter)
        expect(user_id_getter).to receive(:call)
      end

      it 'returns attrs with requested_by_id' do
        service.call

        expect(service.data).to eq({
          'name' => 'Add API',
          'description' => 'Add API to get list of users',
          'labels' => ['web', 'sprint 1'],
          'follower_ids' => [1, 2, 3],
          'project_id' => 100,
          'estimate' => 3.0,
          'story_type' => 'feature',
          'requested_by_id'  => 69
        })
      end
    end

    context 'NOT found user with the initial' do
      let(:user_id_getter) do
        double('Ehpt::GetUserIdFromInitial', call: nil, error?: true, errors: ['Error'])
      end

      before do
        expect(Ehpt::GetUserIdFromInitial).to receive(:new).with('VP').and_return(user_id_getter)
        expect(user_id_getter).to receive(:call)
      end

      it 'returns attrs without requested_by_id' do
        service.call

        expect(service.data).to eq({
          'name' => 'Add API',
          'description' => 'Add API to get list of users',
          'labels' => ['web', 'sprint 1'],
          'follower_ids' => [1, 2, 3],
          'project_id' => 100,
          'estimate' => 3.0,
          'story_type' => 'feature',
        })
      end

      it 'has warnings' do
        service.call

        expect(service.warnings).to eq([
          { row: row, warnings: ['Error'] }
        ])
      end
    end
  end

  context 'there is NO requested_by attr' do
    let(:row) { base_row }

    it 'returns correct attrs' do
      service.call

      expect(service.data).to eq({
        'name' => 'Add API',
        'description' => 'Add API to get list of users',
        'labels' => ['web', 'sprint 1'],
        'follower_ids' => [1, 2, 3],
        'project_id' => 100,
        'estimate' => 3.0,
        'story_type' => 'feature',
      })
    end
  end
end
