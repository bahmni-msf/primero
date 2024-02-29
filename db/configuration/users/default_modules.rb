# frozen_string_literal: true

# Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

PrimeroModule.create_or_update!(
  unique_id: 'primeromodule-cp',
  name: 'POTM',
  description: 'People On The Move',
  associated_record_types: %w[case],
  form_sections: FormSection.where(
    unique_id: %w[
      activities assessment basic_identity best_interest
      care_arrangements care_assessment child_under_5 bia_documents
      closure_form consent followup
      interview_details other_documents other_identity_details partner_details
      photos_and_audio protection_concern_details protection_concern
      record_owner services verification bid_documents
      followup reunification_details other_reportable_fields_case
      referral_transfer notes cp_case_plan cp_bia_form
      cp_individual_details cp_offender_details cp_other_reportable_fields
      approvals conference_details_container
      referral transfer_assignments change_logs registry_from_case registry_details
    ]
  ),
  field_map: {
    map_to: 'primeromodule-cp',
    fields: [
      {
        source: %w[age],
        target: 'age'
      },
      {
        source: %w[sex],
        target: 'cp_sex'
      },
      {
        source: %w[nationality],
        target: 'cp_nationality'
      },
      {
        source: %w[national_id_no],
        target: 'national_id_no'
      },
      {
        source: %w[other_id_type],
        target: 'other_id_type'
      },
      {
        source: %w[other_id_no],
        target: 'other_id_no'
      },
      {
        source: %w[maritial_status],
        target: 'maritial_status'
      },
      {
        source: %w[educational_status],
        target: 'educational_status'
      },
      {
        source: %w[occupation],
        target: 'occupation'
      },
      {
        source: %w[disability_type],
        target: 'cp_disability_type'
      },
      {
        source: %w[owned_by],
        target: 'owned_by'
      }
    ]
  },
  module_options: {
    workflow_status_indicator: true,
    allow_searchable_ids: true,
    use_workflow_service_implemented: true,
    use_workflow_case_plan: true,
    use_workflow_assessment: false,
    reporting_location_filter: false
  },
  primero_program: PrimeroProgram.find_by(unique_id: 'primeroprogram-primero')
)
