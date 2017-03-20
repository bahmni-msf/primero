module FieldsHelper

  def field_tag_name(object, field, field_keys=[])
    if field_keys.present?
      "#{object.class.name.underscore.downcase}[#{field_keys.join('][')}]"
    else
      field.tag_name_attribute(object.class.name.underscore.downcase)
    end
  end

  def field_format_date(a_date)
    if a_date.present? && a_date.is_a?(Date) || a_date.is_a?(Time)
      a_date.strftime("%d-%b-%Y")
    else
      a_date
    end
  end

  def field_value(object, field, field_keys=[])
    if field.nil?
      object.value_for_attr_keys(field_keys)
    elsif field_keys.include? "template"
       # If 'template' exists in the field_keys, this is a new subform
       # The 'template' key is later replaced with the proper index value via JavaScript
       # But for now, there is no value so just return empty string
       ''
    elsif field.is_yes_no?
      parent_obj = object.value_for_attr_keys(field_keys[0..-2])
      value = field.convert_true_false_key_to_string(parent_obj.try(field.name))
    else
      parent_obj = object.value_for_attr_keys(field_keys[0..-2])
      case field.type
      when Field::TALLY_FIELD
        (field.tally + ['total']).map {|t| parent_obj.try(:[],"#{field.name}_#{t}") }
      when Field::DATE_RANGE
        [field_format_date(parent_obj.try(:[],"#{field.name}_from")), field_format_date(parent_obj.try(:[],"#{field.name}_to"))]
      when Field::DATE_FIELD
        field_format_date(parent_obj.try(:[],field.name))
      else
        parent_obj.try(:[],field.name) || parent_obj.try(field.name) || ''
      end
    end
  end

  def field_value_for_display(field_value, field=nil)
    if (field.present? && field.selectable?)
      if field_value.is_a?(Array)
        field_value.map!{|v| field.display_text(v)}
      else
        field_value = field.display_text(field_value)
      end
    end

    return '' if field_value.blank?

    if field_value.is_a?(Array)
      field_value = field_value.join ", "
    elsif field_value.is_a?(Date)
      field_value = field_format_date(field_value)
    end

    return  field_value.to_s
  end

  def select_options(field, record=nil, lookups=nil, exclude_empty_item=false)
    select_options = []
    if field.present?
      select_options << [I18n.t("fields.select_box_empty_item"), ''] unless (field.type == Field::TICK_BOX || field.multi_select || exclude_empty_item)
      select_options += field.options_list(record, lookups).map {|option| [option['display_text'], option['id']]}
    end
    select_options
  end

  def field_link_for_display(field_value, field)
    link_to(field_value, send("#{field.link_to_path}_path", id: field_value.split('::').first)) if field_value.present?
  end

  def field_value_for_multi_select(field_value, field, parent_obj=nil, lookups=nil)
    if field_value.blank?
      ""
    elsif field.option_strings_source == 'violations'
      # This is about the cleanest way to do this without totally reworking the
      # template logic.  Just hope we don't ever have any relevant fields
      # nested more than one level
      if parent_obj['couchrest-type'] != 'Incident'
        inc = parent_obj.casted_by
      else
        inc = parent_obj
      end

      field_value.map do |violation_id|
        vtype, violation = inc.find_violation_by_unique_id(violation_id)
        inc.violation_label(vtype, violation, true)
      end.join('; ')
    else
      options = []
      if field_value.is_a?(Array)
        has_lookup = field.option_strings_source.match(/lookup-.*/)
        
        lookup = lookups.select{|l| l.id == has_lookup[0]}.first if has_lookup
        
        field_value.each do |option|
          if lookup.present?
            lookup_value = lookup.lookup_values.select{|lv| lv["id"] == option}.first
            options << lookup_value["display_text"] if lookup_value.present?
          else
            selected = (field.option_strings_text.is_a?(Array) ? field.option_strings_text.select{|o| o['id'] == option} : option)
            options << selected
          end
        end
      end
      return options.flatten.collect{|a| a['display_text'] || a }.join(', ')
    end
  end

  def field_keys(subform_name, subform_index, field_name, form_group_name)
    field_key = []

    if form_group_name.present? and form_group_name == "Violations"
      field_key << form_group_name.downcase
    end

    if subform_name.present?
      field_key << subform_name << subform_index
    end

    field_key << field_name

    return field_key
  end

  def subforms_count(object, field, form_group_name = "")
    subforms_count = 0
    # This is for shared subforms
    shared_subform = field.subform_section.shared_subform.downcase if field.subform_section.try(:shared_subform)
    shared_subform_group = field.subform_section.shared_subform_group.downcase if field.subform_section.try(:shared_subform_group)

    # needed for all derived subforms
    if object.try(field.name).present?
      subforms_count = object.try(field.name).count
    # needed for all the regular subforms
    elsif object.try(:[], field.name).present?
      subforms_count = object.try(:[], field.name).count
    elsif object[shared_subform].present?
      object[shared_subform].count
    elsif object[form_group_name.downcase].present? && object[form_group_name.downcase][field.name].present?
      subforms_count = object[form_group_name.downcase][field.name].count
    elsif object[shared_subform_group].present? && object[shared_subform_group][shared_subform].present?
      subforms_count = object[shared_subform_group][shared_subform].count
    end
    return subforms_count
  end

  def get_subform_object(object, subform_section, form_group_name, subform_name)
    subform_object = {}
    if form_group_name.present? && form_group_name == "Violations" && object[form_group_name.downcase].present?
      subform_object = object[form_group_name.downcase][subform_section.unique_id]
    #TODO: This code is being temporarily removed until JOR-141 (users should only see their own referrals) is again revisited,
    #      Pending a full refactor of how we do nested forms headers  
    # elsif subform_name == "transitions"
    #   subform_object = object.try(:"#{subform_name}")
    #   #if user is record owner, they can see all referrals
    #   if subform_object.present? && object.owned_by != @current_user.user_name
    #     subform_object = subform_object.select do |transition|
    #       if transition.type == Transition::TYPE_REFERRAL
    #         @current_user.is_admin? ||
    #         @current_user.has_group_permission?(Permission::GROUP) ||
    #         transition.to_user_local == @current_user.user_name
    #       else
    #         true
    #       end
    #     end
    #   end
    else
      subform_object = object.try(:"#{subform_name}")
    end
    return subform_object
  end

  def violation_status(formObject, form_group_name, subform_name, index)
    if formObject[form_group_name.downcase].present? && !formObject[form_group_name.downcase][subform_name].empty? &&
      index != 'template'
      content_tag :span, class: 'verification_status' do
        "(#{formObject[form_group_name.downcase][subform_name][index].verified})"
      end
    end
  end

  #Return the corresponding template to render the field.
  #Edit mode and show mode might have different ways to render fields.
  #Returns custom_template if defined.
  def field_template_path(field, is_show=false)
    return field.custom_template if field.custom_template.present?
    if is_show
      "form_section/field_display_#{field.display_type}"
    else
      "form_section/#{field.type}"
    end
  end

  def option_string_source_data_attr(source)
    if source.present?
      source_match = source.match /lookup-.*/
      if source_match
        source_match[0]
      else  
        source
      end
    end
  end
end
