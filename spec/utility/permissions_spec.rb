# rubocop:disable RSpec/NestedGroups, RSpec/InstanceVariable

describe Permissions, :tag_helper do
  seed_tags

  describe 'initalizing with user with edit and list permissions' do
    let(:user) { create_basic_user }
    let(:permission) { Permissions.new(user) }

    it 'initializes with user' do
      expect(permission.instance_variable_get('@user')).to eq user
    end

    it 'editor? returns true' do
      expect(permission.editor?).to be true
    end

    it 'lister? returns true' do
      expect(permission.lister?).to be true
    end

    it 'admin? returns false' do
      expect(permission.admin?).to be false
    end

    it 'deleter? returns false' do
      expect(permission.deleter?).to be false
    end
  end

  describe 'tag permisions' do
    let(:open_tag) { Tag.find_by(name: 'oil') }
    let(:closed_tag) { Tag.find_by(name: 'nyc') }

    let(:owner) { create_really_basic_user }
    let(:non_owner) { create_really_basic_user }
    let(:admin) { create_admin_user }

    let(:full_access) { { viewable: true, editable: true } }
    let(:view_only_access) { { viewable: true, editable: false } }

    before do
      access_rules = { tag_ids: [open_tag.id, closed_tag.id] }
      owner.user_permissions.create(resource_type: 'Tag',
                                    access_rules: access_rules)
    end

    describe 'any tag' do
      it 'can be viewed but not edited by an anonymous user' do
        expect(Permissions.anon_tag_permissions).to eq view_only_access
      end
    end

    describe 'an open tag' do
      it 'can be viewed and edited by any logged in user' do
        expect(non_owner.permissions.tag_permissions(open_tag)).to eq full_access
      end

      it 'can be viewed by the owner'  do
        expect(owner.permissions.tag_permissions(open_tag)).to eq full_access
      end
    end

    describe 'a closed tag' do
      it 'can be viewed by any logged in user but only edited by its owner(s) or an admin' do
        expect(owner.permissions.tag_permissions(closed_tag)).to eq full_access
        expect(non_owner.permissions.tag_permissions(closed_tag)).to eq view_only_access
        expect(admin.permissions.tag_permissions(closed_tag)).to eq full_access
      end

      it 'can have edit permissions granted to a new user' do
        expect(non_owner.permissions.tag_permissions(closed_tag)).to eq view_only_access
        non_owner.permissions.add_permission(Tag, tag_ids: [closed_tag.id])
        expect(non_owner.permissions.tag_permissions(closed_tag)).to eq full_access
      end

      it 'can have edit permissions revoked from an owner' do
        expect(owner.permissions.tag_permissions(closed_tag)).to eq full_access
        owner.permissions.remove_permission(Tag, tag_ids: [closed_tag.id])
        expect(owner.permissions.tag_permissions(closed_tag)).to eq view_only_access
      end

    end
  end

  describe 'list permisions' do
    before do
      @creator = create_basic_user
      @non_creator = create_really_basic_user
      @lister = create_basic_user # basic_user === lister (see spec/support/helpers.rb)
      @admin = create_admin_user
    end

    context 'with an open list' do

      before do
        @open_list = build(:list, access: Permissions::ACCESS_OPEN, creator_user_id: @creator.id)
      end

      describe 'anon user' do
        it 'cannot view but not edit or configure the list' do
          expect(Permissions.anon_list_permissions(@open_list))
            .to eq(viewable: true,
                   editable: false,
                   configurable: false)
        end
      end

      context 'when logged-in as the creator' do
        it 'can view, edit, and configure the list' do
          expect(@creator.permissions.list_permissions(@open_list))
            .to eq(viewable: true,
                   editable: true,
                   configurable: true)
        end
      end

      context 'when logged-in as a non-creator' do
        it 'can view, but no edit, or configure the list' do
          expect(@non_creator.permissions.list_permissions(@open_list))
            .to eq(viewable: true,
                   editable: false,
                   configurable: false)
        end
      end

      describe 'lister' do
        it 'can be viewed and edited, but not configured' do
          expect(@lister.permissions.list_permissions(@open_list))
            .to eq(viewable: true,
                   editable: true,
                   configurable: false)
        end
      end

      describe 'admin' do
        it 'can view, edit, and configure' do
          expect(@admin.permissions.list_permissions(@open_list))
            .to eq(viewable: true,
                   editable: true,
                   configurable: true)
        end
      end # admin
    end # open list

    context 'with a closed list' do
      before do
        @closed_list = build(:list, access: Permissions::ACCESS_CLOSED, creator_user_id: @creator.id)
      end

      context 'anon user' do
        it 'can view but not edit or configure the list' do
          expect(Permissions.anon_list_permissions(@closed_list))
            .to eq(viewable: true,
                   editable: false,
                   configurable: false)
        end
      end

      context 'when logged-in as the creator' do
        it 'can view, edit, and configure the list' do
          expect(@creator.permissions.list_permissions(@closed_list))
            .to eq(viewable: true,
                   editable: true,
                   configurable: true)
        end
      end

      context 'when logged-in as the non-creator' do
        it 'can view, but no edit, or configure the list' do
          expect(@non_creator.permissions.list_permissions(@closed_list))
            .to eq(viewable: true,
                   editable: false,
                   configurable: false)
        end
      end

      describe 'lister' do
        it 'can be viewed and edited, but not configured' do
          expect(@lister.permissions.list_permissions(@closed_list))
            .to eq(viewable: true,
                   editable: false,
                   configurable: false)
        end
      end

      describe 'admin' do
        it 'can view, edit, and configure' do
          expect(@admin.permissions.list_permissions(@closed_list))
            .to eq(viewable: true,
                   editable: true,
                   configurable: true)
        end
      end
    end # closed list

    context 'with a private list' do
      let(:all_false) do
        {
          viewable: false,
          editable: false,
          configurable: false
        }
      end

      before do
        @private_list = build(:private_list, creator_user_id: @creator.id)
      end

      describe 'anon user' do
        it 'can not view, eidt or configure the list' do
          expect(Permissions.anon_list_permissions(@private_list)).to eq all_false
        end
      end

      context 'when logged-in as the creator' do
        it 'can view, edit, and configure the list' do
          expect(@creator.permissions.list_permissions(@private_list))
            .to eq(viewable: true,
                   editable: true,
                   configurable: true)
        end
      end

      context 'when logged-in as a non-creator' do
        it 'cannot view, edit, or configure the list' do
          expect(@non_creator.permissions.list_permissions(@private_list)).to eq all_false
        end
      end

      describe 'lister' do
        it 'cannot view, edit, or configure the list' do
          expect(@lister.permissions.list_permissions(@private_list)).to eq all_false
        end
      end

      describe 'admin' do
        it 'can view, edit, and configure' do
          expect(@admin.permissions.list_permissions(@private_list))
            .to eq(viewable: true,
                   editable: true,
                   configurable: true)
        end
      end
    end # private list
  end # list permissions

  describe 'entity permissions' do
    subject { Permissions.new(user).entity_permissions(@entity) }

    let(:user) { create_really_basic_user }

    with_versioning do
      before do
        PaperTrail.request(whodunnit: user.id.to_s) do
          @entity = create(:entity_person)
        end
      end

      context 'when the entity was created recently by the user' do
        it 'the creator can delete the entity' do
          expect(subject[:deleteable]).to be true
        end

        it 'the creator cannot merge the entity' do
          expect(subject[:mergeable]).to be false
        end

        it 'other users cannot delete or merge the entity' do
          expect(Permissions.new(create_really_basic_user).entity_permissions(@entity))
            .to eql(mergeable: false, deleteable: false)
        end
      end

      context 'when the entity was recently created, but has more than 2 relationships' do
        before { expect(@entity).to receive(:link_count).and_return(4) }

        it 'the creator cannot delete the entity' do
          expect(subject[:deleteable]).to be false
        end
      end

      context 'when the entity was created more than a week ago' do
        before { expect(@entity).to receive(:created_at).and_return(1.month.ago) }

        it 'the creator cannot delete the entity' do
          expect(subject[:deleteable]).to eql false
        end
      end

      context 'with an admin user' do
        let(:user) { create_admin_user }

        it 'admin can delete and merge the entity' do
          expect(subject).to eql(mergeable: true, deleteable: true)
        end
      end

      context 'with a user with delete permissions' do
        let(:user) { create_basic_user }

        before do
          user.add_ability!(:delete)
          allow(@entity).to receive(:created_at).and_return(1.month.ago)
        end

        it 'deleter can delete the entity' do
          expect(subject).to eql(mergeable: false, deleteable: true)
        end
      end
    end
  end # entity permissions

  describe 'relationship permissions' do
    subject { permissions.relationship_permissions(relationship) }

    let(:abilities) { UserAbilities.new(:edit) }
    let(:user) { build(:user, abilities: abilities) }
    let(:relationship) { build(:generic_relationship, created_at: Time.current) }
    let(:permissions) { Permissions.new(user) }

    let(:legacy_permissions) { [] }

    context 'when the user created the relationship' do
      before do
        allow(permissions).to receive(:user_is_creator?)
                                .with(relationship)
                                .and_return(true)
      end

      context 'when relationship is new' do
        specify { expect(subject[:deleteable]).to be true }
      end

      context 'when the relationship is more than a week old' do
        let(:relationship) { build(:generic_relationship, created_at: 2.weeks.ago) }
        specify { expect(subject[:deleteable]).to be false }
      end

      context 'when the relationship is a campaign contribution' do
        let(:relationship) do
          build(:donation_relationship,
                created_at: Time.current,
                description1: 'NYS Campaign Contribution',
                filings: 2)
        end

        specify { expect(subject[:deleteable]).to be false }
      end
    end

    context 'when the user did not create the relationship' do
      before do
        expect(permissions).to receive(:user_is_creator?)
                                .with(relationship)
                                .and_return(false)
      end

      context 'when relationship is new' do
        specify { expect(subject[:deleteable]).to be false }
      end
    end

    context 'when user is a deleter' do
      let(:abilities) { UserAbilities.new(:edit, :delete) }

      specify { expect(subject[:deleteable]).to be true }
    end

    context 'when user is an admin' do
      let(:abilities) { UserAbilities.new(:edit, :admin) }

      context 'when relationship is new' do
        specify { expect(subject[:deleteable]).to be true }
      end
    end
  end
end # Permissions

describe Permissions::TagAccessRules do
  it 'expands access' do
    expect(
      Permissions::TagAccessRules.update({ tag_ids: [1, 2] },
                                                 { tag_ids: [2, 3] },
                                                 :union)
    ).to eq(tag_ids: [1, 2, 3])
  end

  it 'restricts access' do
    expect(
      Permissions::TagAccessRules.update({ tag_ids: [1, 2] },
                                                 { tag_ids: [2] },
                                                 :difference)
    ).to eq(tag_ids: [1])
  end

  it 'handles nil access rules' do
    expect(
      Permissions::TagAccessRules.update(nil,
                                                 { tag_ids: [2, 3] },
                                                 :union)
    ).to eq(tag_ids: [2, 3])
  end

  it 'raises error if passed an invalid set operation' do
    expect { Permissions::TagAccessRules.update(nil, nil, :foobar) }
      .to raise_error(Permissions::TagAccessRules::InvalidOperationError)
  end
end

# rubocop:enable RSpec/NestedGroups, RSpec/InstanceVariable
