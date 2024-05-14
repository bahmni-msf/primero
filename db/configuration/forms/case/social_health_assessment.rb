social_health_assessment_form_fields = [
  Field.new('name' => 'project_coming_from',
            'type' => 'radio_button',
            'display_name_en' => 'This prpject is coming from which place',
            'option_strings_source' => 'lookup lookup-project_place',
            'disabled' => false,
            'visible' => true),
  Field.new('name' => 'family_of_care',
            'type' => 'select_box',
            'display_name_en' => 'Family of care',
            'option_strings_source' => 'lookup lookup-family-of-care',
            'visible' => true,
            'disabled' => false)
]
FormSection.create_or_update!(
  'visible' => true,
  :order_form_group => 70,
  :order => 1,
  :unique_id => 'social_health_assessment',
  :form_group_id => 'test_Assessment_Form_Group',
  :parent_form => 'case',
  'editable' => false,
  :fields => social_health_assessment_form_fields,
  'name_en' => 'social Health Assessment BE',
  'description_en' => 'social Health Assessment Form BE'
)
