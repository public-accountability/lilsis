require "rails_helper"

describe 'Network Analysis Module', :network_analysis_helper, :pagination_helper, type: :model do

  describe "interlocks" do

    context "for a person" do
      let(:people) { Array.new(4) { create(:entity_person) } }
      let(:person) { people.first }
      let(:orgs) { Array.new(3) { create(:entity_org) } }

      before { interlock_people_via_orgs(people, orgs) }

      context "with less interlocks than pagination limit" do

        it "lists all people in common orgs" do
          expect(person.interlocks.to_a)
            .to eq([
                     {
                       "connected_entity"    => people[3],
                       "connecting_entities" => orgs.take(3),
                       "stat"                => nil
                     },
                     {
                       "connected_entity"    => people[2],
                       "connecting_entities" => orgs.take(2),
                       "stat"                => nil
                     },
                     {
                       "connected_entity"    => people[1],
                       "connecting_entities" => orgs.take(1),
                       "stat"                => nil
                     }
                   ])
        end
      end

      context "with more interlocks than pagination limit" do
        stub_page_limit(Entity)
        # we have to create 1 more person than interlocks we expect to see
        # because the first person is the one to whom the others are interlocked
        let(:people) { Array.new(Entity::PER_PAGE + 2) { create(:entity_person) } }
        let(:person) { people.first }
        it "only shows pagination limit number of interlocks per page" do
          expect(person.interlocks.size).to eq Entity::PER_PAGE
        end

        it "shows the correct page" do
          expect(person.interlocks(2).size).to eql 1
        end
      end
    end

    context "for an org" do
      let(:orgs) { Array.new(4) { create(:entity_org) } }
      let(:org) { orgs.first }
      let(:people) { Array.new(3) { create(:entity_person) } }

      before { interlock_orgs_via_people(orgs, people) }

      context "with less interlocks than pagination limit" do

        it "lists all orgs with common staff or owners" do
          expect(org.interlocks.to_a)
            .to eql([
                      {
                        "connected_entity"    => orgs[3],
                        "connecting_entities" => people.take(3),
                        "stat"                => nil
                      },
                      {
                        "connected_entity"    => orgs[2],
                        "connecting_entities" => people.take(2),
                        "stat"                => nil
                      },
                      {
                        "connected_entity"    => orgs[1],
                        "connecting_entities" => people.take(1),
                        "stat"                => nil
                      }
                    ])
        end
      end
    end
  end

  describe "similar donors" do

    context "for a person" do
      let(:donors) { Array.new(4) { create(:entity_person) } }
      let(:recipients) { [create(:entity_org)] + Array.new(3) { create(:entity_person) } }
      let(:person) { donors.first }

      before { create_donations_from(donors, recipients) }

      it "lists all people who have given to same entities" do
        expect(person.similar_donors.to_a)
          .to eql([
                    {
                      "connected_entity"    => donors[3],
                      "connecting_entities" => recipients.take(3),
                      "stat"                => nil
                    },
                    {
                      "connected_entity"    => donors[2],
                      "connecting_entities" => recipients.take(2),
                      "stat"                => nil
                    },
                    {
                      "connected_entity"    => donors[1],
                      "connecting_entities" => recipients.take(1),
                      "stat"                => nil
                    }
                  ])
          
      end
    end

    context "for an org" do
      let(:recipients) { [create(:entity_org)] + Array.new(3) { create(:entity_person) } }
      let(:donors) { Array.new(3) { create(:entity_person) } }

      before { create_donations_to(recipients, donors) }

      it "lists all orgs who have received donations from the same entities" do
        expect(recipients.first.similar_donors.to_a)
          .to eql([
                    {
                      "connected_entity"    => recipients[3],
                      "connecting_entities" => donors.take(3),
                      "stat"                => 900 # 300 * 3
                    },
                    {
                      "connected_entity"    => recipients[2],
                      "connecting_entities" => donors.take(2),
                      "stat"                => 400 # 200 * 2
                    },
                    {
                      "connected_entity"    => recipients[1],
                      "connecting_entities" => donors.take(1),
                      "stat"                => 100
                    }
                  ])
      end
    end
  end
end
