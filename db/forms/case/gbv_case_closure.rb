case_closure_fields = [
  Field.new({"name" => "created_at",
             "mobile_visible" => true,
             "type" => "date_field",
             "editable" => false,
             "disabled" => true,
             "display_name_all" => "Case Opening Date",
             "create_property" => false,
             "date_include_time" => true
            }),
  Field.new({"name" => "date_closure",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "date_field",
             "display_name_all" => "Case Closure Date"
            }),
  Field.new({"name" => "child_status",
             "mobile_visible" => true,
             "type" =>"select_box" ,
             "selected_value" => Record::STATUS_OPEN,
             "display_name_all" => "Case Status",
             "option_strings_source" => "lookup lookup-case-status"
            }),
  Field.new({"name" => "closure_assessment",
             "mobile_visible" => true,
             "type" => "textarea",
             "display_name_all" => "Closure Assessement"
            }),
  Field.new({"name" => "closure_checklist_header_section",
             "mobile_visible" => true,
             "type" => "separator",
             "display_name_all" => "Closure Checklist"
            }),
  Field.new({"name" => "closure_needs_met",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "Survivor’s needs have been met to the extent possible",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_needs_met_explain",
             "mobile_visible" => true,
             "type" => "textarea",
             "display_name_all" => "Explain",
            }),
  Field.new({"name" => "closure_survivor_contact",
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "There has been no contact with survivor for a specified period (e.g., more than 30 days)",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_survivor_contact_explain",
             "type" => "textarea",
             "display_name_all" => "Explain",
            }),
  Field.new({"name" => "closure_survivor_request_close",
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "Survivor requests to close the case",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_survivor_request_close_explain",
             "type" => "textarea",
             "display_name_all" => "Explain",
            }),
  Field.new({"name" => "closure_survivor_left_area",
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "Survivor left the area or no longer lives there",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_survivor_left_area_explain",
             "type" => "textarea",
             "display_name_all" => "Explain",
            }),
  Field.new({"name" => "closure_tranferred_organization",
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "The case was transferred to another organization",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_tranferred_organization_explain",
             "type" => "textarea",
             "display_name_all" => "Explain",
            }),
  Field.new({"name" => "closure_funding_constraints",
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "The case was closed because of funding constraints of the service provider",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_funding_constraints_explain",
             "type" => "textarea",
             "display_name_all" => "Explain",
            }),
  Field.new({"name" => "closure_safety_plan",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "Survivor’s safety plan has been reviewed and is in place",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_safety_plan_explain",
             "mobile_visible" => true,
             "type" => "textarea",
             "display_name_all" => "Explain (safety plan)",
            }),
  Field.new({"name" => "closure_case_plan_complete",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "Survivor's needs have been met as described in the Case Action Plan",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_case_plan_complete_explain",
             "mobile_visible" => true,
             "type" => "textarea",
             "display_name_all" => "Explain (complete and satisfactory)",
            }),
  Field.new({"name" => "closure_no_further_support",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "The survivor client and caseworker agree that no further support is needed",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_no_further_support_explain",
             "mobile_visible" => true,
             "type" => "textarea",
             "display_name_all" => "Explain (no need for further support)",
            }),
  Field.new({"name" => "closure_resume_notification",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "Survivor has been informed that she can resume services at any time",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_resume_notification_explain",
             "mobile_visible" => true,
             "type" => "textarea",
             "display_name_all" => "Explain (resuming services)",
            }),
  Field.new({"name" => "closure_supervisor_review",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "radio_button",
             "display_name_all" => "Case supervisor has reviewed case closure/exit plan",
             "option_strings_source" => "lookup lookup-yes-no"
            }),
  Field.new({"name" => "closure_supervisor_review_explain",
             "mobile_visible" => true,
             "type" => "textarea",
             "display_name_all" => "Explain (case review)",
            }),
  Field.new({"name" => "closure_completion_timing",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "How long did it take you to complete the case closure for this case?",
             "option_strings_source" => "lookup lookup-assessment-duration"
            })
]

FormSection.create_or_update_form_section({
  unique_id: "gbv_case_closure_form",
  parent_form: "case",
  visible: true,
  order_form_group: 120,
  order: 80,
  order_subform: 0,
  form_group_name: "Case Closure",
  editable: true,
  fields: case_closure_fields,
  mobile_form: true,
  name_all: "Case Closure",
  description_all: "Case Closure"
})
