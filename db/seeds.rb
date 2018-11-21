# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

ExtensionDefinition.create!([
  {name: "Person", display_name: "Person", has_fields: true, parent_id: nil, tier: 1, id: 1},
  {name: "Org", display_name: "Organization", has_fields: true, parent_id: nil, tier: 1, id: 2}
])

ExtensionDefinition.create!([
  {name: "PoliticalCandidate", display_name: "Political Candidate", has_fields: true, parent_id: 1, tier: 2, id: 3},
  {name: "ElectedRepresentative", display_name: "Elected Representative", has_fields: true, parent_id: 1, tier: 2, id: 4},
  {name: "Business", display_name: "Business", has_fields: true, parent_id: 2, tier: 2, id: 5},
  {name: "GovernmentBody", display_name: "Government Body", has_fields: true, parent_id: 2, tier: 2, id: 6},
  {name: "School", display_name: "School", has_fields: true, parent_id: 2, tier: 2, id: 7},
  {name: "MembershipOrg", display_name: "Membership Organization", has_fields: false, parent_id: 2, tier: 2, id: 8},
  {name: "Philanthropy", display_name: "Philanthropy", has_fields: false, parent_id: 2, tier: 2, id: 9},
  {name: "NonProfit", display_name: "Other Not-for-Profit", has_fields: false, parent_id: 2, tier: 2, id: 10},
  {name: "PoliticalFundraising", display_name: "Political Fundraising Committee", has_fields: true, parent_id: 2, tier: 2, id: 11},
  {name: "PrivateCompany", display_name: "Private Company", has_fields: false, parent_id: 2, tier: 3, id: 12},
  {name: "PublicCompany", display_name: "Public Company", has_fields: true, parent_id: 2, tier: 3, id: 13},
  {name: "IndustryTrade", display_name: "Industry/Trade Association", has_fields: false, parent_id: 2, tier: 3, id: 14},
  {name: "LawFirm", display_name: "Law Firm", has_fields: false, parent_id: 2, tier: 3, id: 15},
  {name: "LobbyingFirm", display_name: "Lobbying Firm", has_fields: false, parent_id: 2, tier: 3, id: 16},
  {name: "PublicRelationsFirm", display_name: "Public Relations Firm", has_fields: false, parent_id: 2, tier: 3, id: 17},
  {name: "IndividualCampaignCommittee", display_name: "Individual Campaign Committee", has_fields: false, parent_id: 2, tier: 3, id: 18},
  {name: "Pac", display_name: "PAC", has_fields: false, parent_id: 2, tier: 3, id: 19},
  {name: "OtherCampaignCommittee", display_name: "Other Campaign Committee", has_fields: false, parent_id: 2, tier: 3, id: 20},
  {name: "MediaOrg", display_name: "Media Organization", has_fields: false, parent_id: 2, tier: 3, id: 21},
  {name: "ThinkTank", display_name: "Policy/Think Tank", has_fields: false, parent_id: 2, tier: 3, id: 22},
  {name: "Cultural", display_name: "Cultural/Arts", has_fields: false, parent_id: 2, tier: 3, id: 23},
  {name: "SocialClub", display_name: "Social Club", has_fields: false, parent_id: 2, tier: 3, id: 24},
  {name: "ProfessionalAssociation", display_name: "Professional Association", has_fields: false, parent_id: 2, tier: 3, id: 25},
  {name: "PoliticalParty", display_name: "Political Party", has_fields: false, parent_id: 2, tier: 3, id: 26},
  {name: "LaborUnion", display_name: "Labor Union", has_fields: false, parent_id: 2, tier: 3, id: 27},
  {name: "Gse", display_name: "Government-Sponsored Enterprise", has_fields: false, parent_id: 2, tier: 3, id: 28},
  {name: "BusinessPerson", display_name: "Business Person", has_fields: true, parent_id: 1, tier: 2, id: 29},
  {name: "Lobbyist", display_name: "Lobbyist", has_fields: true, parent_id: 1, tier: 2, id: 30},
  {name: "Academic", display_name: "Academic", has_fields: false, parent_id: 1, tier: 2, id: 31},
  {name: "MediaPersonality", display_name: "Media Personality", has_fields: false, parent_id: 1, tier: 3, id: 32},
  {name: "ConsultingFirm", display_name: "Consulting Firm", has_fields: false, parent_id: 2, tier: 3, id: 33},
  {name: "PublicIntellectual", display_name: "Public Intellectual", has_fields: false, parent_id: 1, tier: 3, id: 34},
  {name: "PublicOfficial", display_name: "Public Official", has_fields: false, parent_id: 1, tier: 2, id: 35},
  {name: "Lawyer", display_name: "Lawyer", has_fields: false, parent_id: 1, tier: 2, id: 36},
  {name: "Couple", display_name: "Couple", has_fields: true, parent_id: nil, tier: 1, id: 37},
  {name: "ResearchInstitute", display_name: "Academic Research Institute", has_fields: false, parent_id: 2, tier: 3, id: 38},
  {name: "GovernmentAdvisoryBody", display_name: "Government Advisory Body", has_fields: false, parent_id: 2, tier: 3, id: 39},
  {name: "EliteConsensus", display_name: "Elite Consensus Group", has_fields: false, parent_id: 2, tier: 3, id: 40}
])

SfGuardUser.create!({id: 1, username: "system@littlesis.org", password: 'password', salt:''})
User.create!({id: 1, email: "system@littlesis.org", username: 'system', default_network_id: 79, confirmed_at: Time.now,
              sf_guard_user_id: 1, role: :system,
              password: '$2a$10$Q2tSw2llUagw1KRNTtLD4.JiYgFA.9pxgV5aPOs/IxFsddZGa8jgO'})


SfGuardPermission.create!([
                            {id: 1, name: "admin", description: "Administrator permission"},
                            {id: 2, name: "contributor", description: nil},
                            {id: 3, name: "editor", description: nil},
                            {id: 5, name: "deleter", description: nil},
                            {id: 6, name: "lister", description: "enables users to create lists"},
                            {id: 7, name: "merger", description: "enables users to merge entities"},
                            {id: 8, name: "importer", description: nil},
                            {id: 9, name: "bulker", description: "enables users to add relationships in bulk"},
                            {id: 10, name: "talker", description: "allows user to use web-based chat"},
                            {id: 11, name: "contacter", description: nil}
                          ])

RelationshipCategory.create!([
  {id: 1, name: "Position", display_name: "Position", default_description: "Position", entity1_requirements: "Person", entity2_requirements: nil, has_fields: true},
  {id: 2, name: "Education", display_name: "Education", default_description: "Student", entity1_requirements: "Person", entity2_requirements: "Org", has_fields: true},
  {id: 3, name: "Membership", display_name: "Membership", default_description: "Member", entity1_requirements: nil, entity2_requirements: "Org", has_fields: true},
  {id: 4, name: "Family", display_name: "Family", default_description: "Relative", entity1_requirements: "Person", entity2_requirements: "Person", has_fields: true},
  {id: 5, name: "Donation", display_name: "Donation/Grant", default_description: "Donation/Grant", entity1_requirements: nil, entity2_requirements: nil, has_fields: true},
  {id: 6, name: "Transaction", display_name: "Service/Transaction", default_description: "Service/Transaction", entity1_requirements: nil, entity2_requirements: nil, has_fields: true},
  {id: 7, name: "Lobbying", display_name: "Lobbying", default_description: "Lobbying", entity1_requirements: nil, entity2_requirements: nil, has_fields: true},
  {id: 8, name: "Social", display_name: "Social", default_description: "Social", entity1_requirements: "Person", entity2_requirements: "Person", has_fields: true},
  {id: 9, name: "Professional", display_name: "Professional", default_description: "Professional", entity1_requirements: "Person", entity2_requirements: "Person", has_fields: true},
  {id: 10, name: "Ownership", display_name: "Ownership", default_description: "Owner", entity1_requirements: nil, entity2_requirements: "Org", has_fields: true},
  {id: 11, name: "Hierarchy", display_name: "Hierarchy", default_description: "Hierarchy", entity1_requirements: "Org", entity2_requirements: "Org", has_fields: true},
  {id: 12, name: "Generic", display_name: "Generic", default_description: "Affiliation", entity1_requirements: nil, entity2_requirements: nil, has_fields: true}
])

Degree.create!([
  {id: 1, name: "Doctor of Philosophy", abbreviation: "PhD"},
  {id: 2, name: "Bachelor of Arts", abbreviation: "BA"},
  {id: 3, name: "Master of Business Administration", abbreviation: "MBA"},
  {id: 4, name: "Bachelor of Science", abbreviation: "BS"},
  {id: 5, name: "Juris Doctor", abbreviation: "JD"},
  {id: 6, name: "Bachelor's Degree", abbreviation: nil},
  {id: 7, name: "Bachelor of Laws", abbreviation: "LLB"},
  {id: 8, name: "Master's Degree", abbreviation: nil},
  {id: 9, name: "Master of Science", abbreviation: "MS"},
  {id: 10, name: "Doctorate", abbreviation: nil},
  {id: 11, name: "Associate's Degree", abbreviation: nil},
  {id: 12, name: "Honorus Degree", abbreviation: nil},
  {id: 13, name: "Honorary Doctorate", abbreviation: nil},
  {id: 14, name: "Doctor of Science", abbreviation: "ScD"},
  {id: 15, name: "Master of Arts", abbreviation: "MA"},
  {id: 16, name: "Bachelor of Science in Business Administration", abbreviation: "BSBA"},
  {id: 17, name: "Doctor of Medicine", abbreviation: "MD"},
  {id: 18, name: "Post-Doctoral Training", abbreviation: nil},
  {id: 19, name: "Master of Engineering", abbreviation: "ME"},
  {id: 20, name: "Bachelor of Science in Engineering", abbreviation: "BSE"},
  {id: 21, name: "Bachelor of Engineering", abbreviation: "BE"},
  {id: 22, name: "Associate of Arts", abbreviation: "AA"},
  {id: 23, name: "Associate of Science", abbreviation: "AS"},
  {id: 24, name: "Postgraduate Diploma", abbreviation: nil},
  {id: 25, name: "Drop Out", abbreviation: nil},
  {id: 26, name: "Medical Doctor", abbreviation: nil},
  {id: 27, name: "Registered Nurse", abbreviation: nil},
  {id: 28, name: "Master of Laws", abbreviation: "LLM"},
  {id: 29, name: "Master of Public Administration", abbreviation: nil},
  {id: 30, name: "High School Diploma", abbreviation: nil},
  {id: 31, name: "Doctor of Education", abbreviation: nil},
  {id: 32, name: "Master of Public Policy", abbreviation: nil},
  {id: 33, name: "Bachelor of Science in Economics", abbreviation: nil},
  {id: 34, name: "Bachelor of Science in Finance", abbreviation: nil},
  {id: 35, name: "Certificate", abbreviation: nil},
  {id: 36, name: "Master of Public Health", abbreviation: nil},
  {id: 37, name: "Bachelor of Business Administration", abbreviation: nil},
  {id: 38, name: "Master of International Relations", abbreviation: nil}
])

AddressState.create!([
  {name: "Alaska", abbreviation: "AK", country_id: 1},
  {name: "Alabama", abbreviation: "AL", country_id: 1},
  {name: "American Samoa", abbreviation: "AS", country_id: 1},
  {name: "Arizona", abbreviation: "AZ", country_id: 1},
  {name: "Arkansas", abbreviation: "AR", country_id: 1},
  {name: "California", abbreviation: "CA", country_id: 1},
  {name: "Colorado", abbreviation: "CO", country_id: 1},
  {name: "Connecticut", abbreviation: "CT", country_id: 1},
  {name: "Delaware", abbreviation: "DE", country_id: 1},
  {name: "District of Columbia", abbreviation: "DC", country_id: 1},
  {name: "Federated States of Micronesia", abbreviation: "FM", country_id: 1},
  {name: "Florida", abbreviation: "FL", country_id: 1},
  {name: "Georgia", abbreviation: "GA", country_id: 1},
  {name: "Guam", abbreviation: "GU", country_id: 1},
  {name: "Hawaii", abbreviation: "HI", country_id: 1},
  {name: "Idaho", abbreviation: "ID", country_id: 1},
  {name: "Illinois", abbreviation: "IL", country_id: 1},
  {name: "Indiana", abbreviation: "IN", country_id: 1},
  {name: "Iowa", abbreviation: "IA", country_id: 1},
  {name: "Kansas", abbreviation: "KS", country_id: 1},
  {name: "Kentucky", abbreviation: "KY", country_id: 1},
  {name: "Louisiana", abbreviation: "LA", country_id: 1},
  {name: "Maine", abbreviation: "ME", country_id: 1},
  {name: "Marshall Islands", abbreviation: "MH", country_id: 1},
  {name: "Maryland", abbreviation: "MD", country_id: 1},
  {name: "Massachusetts", abbreviation: "MA", country_id: 1},
  {name: "Michigan", abbreviation: "MI", country_id: 1},
  {name: "Minnesota", abbreviation: "MN", country_id: 1},
  {name: "Mississippi", abbreviation: "MS", country_id: 1},
  {name: "Missouri", abbreviation: "MO", country_id: 1},
  {name: "Montana", abbreviation: "MT", country_id: 1},
  {name: "Nebraska", abbreviation: "NE", country_id: 1},
  {name: "Nevada", abbreviation: "NV", country_id: 1},
  {name: "New Hampshire", abbreviation: "NH", country_id: 1},
  {name: "New Jersey", abbreviation: "NJ", country_id: 1},
  {name: "New Mexico", abbreviation: "NM", country_id: 1},
  {name: "New York", abbreviation: "NY", country_id: 1},
  {name: "North Carolina", abbreviation: "NC", country_id: 1},
  {name: "North Dakota", abbreviation: "ND", country_id: 1},
  {name: "Northern Mariana Islands", abbreviation: "MP", country_id: 1},
  {name: "Ohio", abbreviation: "OH", country_id: 1},
  {name: "Oklahoma", abbreviation: "OK", country_id: 1},
  {name: "Oregon", abbreviation: "OR", country_id: 1},
  {name: "Palau", abbreviation: "PW", country_id: 1},
  {name: "Pennsylvania", abbreviation: "PA", country_id: 1},
  {name: "Puerto Rico", abbreviation: "PR", country_id: 1},
  {name: "Rhode Island", abbreviation: "RI", country_id: 1},
  {name: "South Carolina", abbreviation: "SC", country_id: 1},
  {name: "South Dakota", abbreviation: "SD", country_id: 1},
  {name: "Tennessee", abbreviation: "TN", country_id: 1},
  {name: "Texas", abbreviation: "TX", country_id: 1},
  {name: "Utah", abbreviation: "UT", country_id: 1},
  {name: "Vermont", abbreviation: "VT", country_id: 1},
  {name: "Virgin Islands", abbreviation: "VI", country_id: 1},
  {name: "Virginia", abbreviation: "VA", country_id: 1},
  {name: "Washington", abbreviation: "WA", country_id: 1},
  {name: "West Virginia", abbreviation: "WV", country_id: 1},
  {name: "Wisconsin", abbreviation: "WI", country_id: 1},
  {name: "Wyoming", abbreviation: "WY", country_id: 1}
])
