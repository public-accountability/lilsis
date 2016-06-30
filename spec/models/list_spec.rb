require 'rails_helper'

describe List do
  # it 'includes SoftDelete' 
  # it 'includes cacheable'
  # it 'includes Referenceable'
  it 'validates name' do
    l = List.new
    expect(l).not_to be_valid
    l.name = "bad politicians"
    expect(l).to be_valid
  end
  context "active relationships" do
    
    it 'joins entities via ListEntity' do
      list = create(:list)
      inc = create(:mega_corp_inc)
      llc = create(:mega_corp_llc)
      # Every time you create an entity you create a ListEntity because all entites
      # are in a network and all networks are lists joined via the list_entities table.
      # This is why there are 2 list_entities to start with.
      expect(ListEntity.count).to eql(2)
      ListEntity.find_or_create_by(list_id: list.id, entity_id: inc.id)
      ListEntity.find_or_create_by(list_id: list.id, entity_id: llc.id)
      expect(ListEntity.count).to eql(4)
      expect(list.list_entities.count).to eql(2)
    end

    it 'has images through entities' do
      list = create(:list)
      inc = create(:mega_corp_inc)
      create(:image, entity_id: inc.id)
      ListEntity.find_or_create_by(list_id: list.id, entity_id: inc.id)
      expect(list.images.count).to eq (1)
      expect(list.images.first.filename).to eql ('image.jpg')
    end

    it 'has groups' do 
      list = create(:list)
      grp = create(:group)
      expect(list.groups.count).to eq (0)
      GroupList.create(list_id: list.id, group_id: grp.id)
      expect(list.groups.count).to eq(1)
      expect(GroupList.count).to eq(1) 
      expect(grp.lists.first).to eq(list)
      expect(list.groups.first).to eq(grp)
    end

    it 'has notes & notelists' do
      list = create(:list)
      note = create(:note)
      expect(list.note_lists.count).to eq(0)
      NoteList.create(list_id: list.id, note_id: note.id)
      expect(list.note_lists.count).to eq(1)
      expect(list.notes.count).to eq(1)
    end

    # it 'has note networks and network_notes'
    # it 'has users through default_network'
    # it 'has sf_guard_group_lists'
    # it 'has topic_lists & topics'
    # it 'has one default topic'
  end
  context 'methods' do
    it 'name_to_legacy_slug' do
      l = build(:list, name: 'my/cool+name')
      expect(l.name_to_legacy_slug).to eq("my~cool_name")
    end
    it 'leagacy_url' do
      list = build(:list, id: 8)
      expect(list.legacy_url).to eq("/list/8/Fortune_1000_Companies")
      expect(list.legacy_url('bam')).to eq("/list/8/Fortune_1000_Companies/bam")
    end
  end
end
