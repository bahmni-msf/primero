// Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

import PropTypes from "prop-types";
import clsx from "clsx";

import { RECORD_TYPES } from "../../../../../../config/constants";
import css from "../../styles.css";
import { useI18n } from "../../../../../i18n";
import FiltersExpansionPanel from "../filters-expansion-panel";
import ActionButton from "../../../../../action-button";
import { ACTION_BUTTON_TYPES } from "../../../../../action-button/constants";

const Component = ({ filterValues, modules, handleSetFilterValue, handleClearValue, disabled }) => {
  const i18n = useI18n();
  const associatedRecordTypes = modules.reduce((prev, current) => {
    return prev.concat(current.associated_record_types);
  }, []);

  const filters = [
    {
      id: "recordType",
      name: "Record Type",
      options: Object.values(RECORD_TYPES).reduce((prev, current) => {
        const obj = prev;

        if (current !== RECORD_TYPES.all && associatedRecordTypes.includes(current)) {
          obj.push({
            displayName: i18n.t(`forms.record_types.${current}`),
            id: current
          });
        }

        return obj;
      }, [])
    },
    {
      id: "primeroModule",
      name: "Module",
      options: modules.reduce((prev, current) => {
        return prev.concat({
          displayName: current.name,
          id: current.unique_id,
          recordTypes: current.associated_record_types
        });
      }, [])
    }
  ];

  const renderExpansionPanels = () =>
    filters.map(filter => (
      <FiltersExpansionPanel
        {...filter}
        key={filter.id}
        handleSetFilterValue={handleSetFilterValue}
        filterValues={filterValues}
      />
    ));
  const classes = clsx({ [css.disabledFilters]: disabled });

  return (
    <div className={classes}>
      <ActionButton
        text="clear"
        type={ACTION_BUTTON_TYPES.default}
        isTransparent
        rest={{
          onClick: handleClearValue,
          variant: "outlined",
          fullWidth: true
        }}
      />

      {renderExpansionPanels()}
    </div>
  );
};

Component.displayName = "FormFilters";

Component.defaultProps = {
  disabled: false,
  filterValues: {}
};

Component.propTypes = {
  disabled: PropTypes.bool,
  filterValues: PropTypes.object,
  handleClearValue: PropTypes.func.isRequired,
  handleSetFilterValue: PropTypes.func.isRequired,
  modules: PropTypes.object.isRequired
};

export default Component;
