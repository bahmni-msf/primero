accomodation_health_assessment_form_fields =[
     Field.new( 'name' => 'place_of_discharge',
                'type' => 'select_box',
                'display_name_en' => 'Place of discharge',
                'option_strings_source' => 'lookup lookup-place-of-discharge',
                'disabled' => false,
                'visible' => true),
    Field.new('name' => 'beni_place_of_discharge',
               'type' => 'select_box',
               'disabled' => false,
               'display_name_en' => 'Structure of Discharge',
               'option_strings_source' => 'lookup lookup-beni-walid-place-of-discharge',
                disabled:true,
               'visible' => true,
                display_conditions_record: {eq: { place_of_discharge: 'beni_walid' } }
                ),
    Field.new('name' => 'misrata_place_of_discharge',
               'type' => 'select_box',
               'disabled' => false,
               'display_name_en' => 'Structure of Discharge',
               'option_strings_source' => 'lookup lookup-misrata_place-of-discharge',
               display_conditions_record: { eq: { place_of_discharge: 'misrata' } },
               'visible' => true),
]

FormSection.create_or_update!(
      'visible' => true,
      :order_form_group => 70,
      :order => 4,
      :unique_id => 'accomodation_health_assessment',
      :form_group_id => 'test_Assessment_Form_Group',
      :parent_form => 'case',
      'editable' => false,
      :fields => accomodation_health_assessment_form_fields,
      'name_en' => 'Accomodation Health Assessment BE',
      'description_en' => 'Accomodation Health Assessment Form BE'
)