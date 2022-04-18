# frozen_string_literal: true

json.array!(@candidate_organizations, partial: 'candidate_organizations/candidate_organization',
                                      as: :candidate_organization)
