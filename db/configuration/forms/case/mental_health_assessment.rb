# frozen_string_literal: true

# Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

mental_health_fields_subform = [
  Field.new(name: 'primary_diagnosis_in_protection',
            type: 'select_box',
            display_name_en: 'what is the primary diagnosis in protection',
            option_strings_source: 'lookup lookup-primary_diagnosis_in_protection',
            visible: true),
  Field.new(name: 'comments',
            type: 'text_field',
            display_name_en: 'Comments'),
  Field.new(name: 'pic',
            type: 'photo_upload_box',
            display_name_en: 'photos')
]

mental_health_sub_section = FormSection.create_or_update!(
  visible: true,
  is_nested: true,
  mobile_form: true,
  order_form_group: 70,
  order: 1,
  order_subform: 2,
  unique_id: 'mental_health_sub_section',
  parent_form: 'case',
  editable: true,
  fields: mental_health_fields_subform,
  initial_subforms: 2,
  name_en: 'Nested Mental Health BE',
  description_en: 'Nested Mental Health BE'
)

mental_health_fields = [
  Field.new(
    name: 'pic',
    type: 'photo_upload_box',
    display_name_en: 'photos'
  ),
  Field.new(
    name: 'assessment_approved',
    type: 'tick_box',
    tick_box_label_en: 'Yes',
    display_name_en: 'Approved by Manager',
    disabled: true,
    editable: false
  ),
  Field.new(
    name: 'assessment_approved_date',
    type: 'date_field',
    display_name_en: 'Date',
    disabled: true,
    editable: false
  ),
  Field.new(
    name: 'assessment_approved_comments',
    type: 'textarea',
    display_name_en: 'Manager Comments',
    disabled: true,
    editable: false
  ),
  Field.new(
    name: 'approval_status_assessment',
    type: 'select_box',
    display_name_en: 'Approval Status',
    option_strings_source: 'lookup lookup-approval-status',
    disabled: true,
    editable: false
  ),
  Field.new(
    name: 'assessment_requested_on',
    display_name_en: 'Assessment started on',
    help_text_en: 'This field is used for the Workflow status.',
    type: 'date_field',
    editable: false
  ),
  Field.new(
    type: 'date_field',
    display_name_en: 'Date Case Plan Due',
    name: 'case_plan_due_date',
    required: false,
    editable: true
  ),
  Field.new(name: 'mental_place_of_discharge',
            type: 'select_box',
            display_name_en: 'Mental Place of discharge',
            option_strings_source: 'lookup lookup-place-of-discharge',
            disabled: false,
            visible: true),
  Field.new(
    type: 'date_field',
    display_name_en: 'Date Mental Health',
    name: 'date_mental_health',
    required: false,
    editable: true
  ),
  Field.new(
    name: 'mental_health_sub_section',
    type: 'subform',
    editable: true,
    subform_section: mental_health_sub_section,
    display_name_en: 'Mental Health Sub Form BE',
    display_conditions_subform: { eq: { mental_place_of_discharge: 'beni_walid' } }
  )
]

FormSection.create_or_update!(
  unique_id: 'mental_health_assessment',
  parent_form: 'case',
  visible: true,
  order_form_group: 70,
  order: 2,
  order_subform: 0,
  form_group_id: 'test_Assessment_Form_Group',
  fields: mental_health_fields,
  editable: false,
  name_en: 'Mental Health Assessment BE changed',
  description_en: 'Mental Health Assessment Form BE changed'
)
