// Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

import { fromJS } from "immutable";

import { FieldRecord, FormSectionRecord, CHECK_BOX_FIELD } from "../../../../form";
import { RESOURCES, FORM_CHECK_ERRORS } from "../constants";
import { RECORD_TYPES } from "../../../../../config/constants";
import { useApp } from "../../../../application";

import { buildPermissionOptions } from "./utils";
import AssociatedRolesForm from "./associated-roles";
import InsightsScopeForm from "./insights-scope-form";

export default (resourceActions, i18n, approvalsLabels) =>
  RESOURCES.filter(resource => {

    const { userModules } = useApp();
    const associatedRecordTypes = userModules.reduce((prev, current) => {
      return prev.concat(current.associated_record_types);
    }, []);

    if (Object.values(RECORD_TYPES).includes(resource) && associatedRecordTypes.includes(resource) == false) {
      return false;
    }

    return resourceActions.has(resource);
  }).map(resource => {
    const actions = (resourceActions || fromJS({})).get(resource, fromJS([]));

    if (resource === "role") {
      return AssociatedRolesForm(actions, i18n);
    }

    if (resource === "managed_report") {
      return InsightsScopeForm(actions, i18n);
    }

    return FormSectionRecord({
      unique_id: `resource_actions_${resource}`,
      name: i18n.t(`permissions.permission.${resource}`),
      fields: [
        FieldRecord({
          name: `permissions[${resource}]`,
          type: CHECK_BOX_FIELD,
          option_strings_text: buildPermissionOptions(actions, i18n, resource, approvalsLabels) || []
        })
      ],
      expandable: true,
      expanded: true,
      check_errors: fromJS(FORM_CHECK_ERRORS)
    });
  });
