describe Ehpt::GetUserIdFromInitial do
  let(:project) { double('PT project', memberships: memberships) }
  let(:initial) { 'VP' }
  let(:service) { described_class.new(initial) }

  before do
    allow(Ehpt).to receive(:project).and_return(project)
  end

  after do
    Ehpt::GetUserIdFromInitial.memberships = nil
  end

  describe '#fetch_memberships_from_pt!' do
    let(:memberships) { [] }

    it 'fetches only if memberships is nil' do
      service.call
      service.call
      expect(project).to have_received(:memberships).once
    end
  end

  describe '#call' do
    context 'user found' do
      let(:memberships) do
        [
          double('Membership', person: double('Person', initials: 'Vp', id: 23)),
          double('Membership', person: double('Person', initials: 'Foo', id: 10))
        ]
      end

      it 'return user id' do
        service.call

        expect(service.success?).to eq(true)
        expect(service.data).to eq(23)
      end
    end

    context 'user NOT found' do
      let(:memberships) do
        [
          double('Membership', person: double('Person', initials: 'Bar', id: 23)),
          double('Membership', person: double('Person', initials: 'Foo', id: 10))
        ]
      end

      it 'has errors' do
        service.call

        expect(service.error?).to eq(true)
        expect(service.errors).to eq(['Not found any user with initial VP'])
      end
    end
  end
end
