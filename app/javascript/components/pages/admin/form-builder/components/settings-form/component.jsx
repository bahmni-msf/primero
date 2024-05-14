// Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

import PropTypes from "prop-types";

import FormSection from "../../../../../form/components/form-section";
import { useI18n } from "../../../../../i18n";
import { settingsForm } from "../../forms";
import { useApp } from "../../../../../application";

function Component({ formMethods, formMode, onManageTranslation, onEnglishTextChange, limitedProductionSite }) {
  const i18n = useI18n();
  const { userModules } = useApp();
  const moduleAssociatedRecordTypes = userModules.reduce(
    (prev, current) => [
      ...prev,
      {
        id: current.get("unique_id"),
        associated_record_types: current.get("associated_record_types")
      }
    ],
    []
  );

  return settingsForm({ formMode, onManageTranslation, onEnglishTextChange, i18n, limitedProductionSite, moduleAssociatedRecordTypes }).map(
    formSection => (
      <FormSection
        formSection={formSection}
        key={formSection.unique_id}
        formMethods={formMethods}
        formMode={formMode}
      />
    )
  );
}

Component.displayName = "SettingsForm";

Component.propTypes = {
  formMethods: PropTypes.object,
  formMode: PropTypes.object,
  limitedProductionSite: PropTypes.bool,
  onEnglishTextChange: PropTypes.func,
  onManageTranslation: PropTypes.func
};

export default Component;
