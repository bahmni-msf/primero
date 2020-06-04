import React from "react";
import { format } from "date-fns";
import PropTypes from "prop-types";
import { Grid } from "@material-ui/core";
import Chip from "@material-ui/core/Chip";
import clsx from "clsx";

import { useI18n } from "../../../i18n";
import { NAME_SUMMARY } from "../../constants";
import { useApp } from "../../../application";

const Component = ({ approvalSubform, css, isRequest, isResponse }) => {
  const i18n = useI18n();
  const { approvalsLabels } = useApp();
  const status = approvalSubform.get("approval_status");

  const title =
    isRequest && !isResponse
      ? i18n.t("approvals.requested_for_title")
      : i18n.t("approvals.response_for_title");

  const renderApprovalValue =
    isRequest && !isResponse
      ? approvalsLabels[approvalSubform.get("approval_requested_for")]
      : approvalsLabels[approvalSubform.get("approval_response_for")];

  const renderStatus = isResponse ? (
    <Grid item md={2} xs={4}>
      <div className={css.approvalsStatus}>
        <Chip
          label={i18n.t(`approvals.status.${status}`)}
          className={clsx(css.chip, css[status])}
          size="small"
        />
      </div>
    </Grid>
  ) : null;

  const renderApprovalDate = () => {
    const approvalDate = approvalSubform.get("approval_date", false);

    if (!approvalDate) {
      return false;
    }

    return format(new Date(approvalDate), "MMM dd,yyyy");
  };

  return (
    <Grid container spacing={2}>
      <Grid item md={10} xs={8}>
        <div className={css.wrapper}>
          <div className={css.titleHeader}>{title}</div>
          <div className={css.approvalsValueSummary}>{renderApprovalValue}</div>
          <div className={(css.approvalsValueSummary, css.separator)}>-</div>
          {/* TODO: The date should be localized */}
          <div className={css.approvalsValueSummary}>
            {renderApprovalDate()}
          </div>
        </div>
      </Grid>
      {renderStatus}
    </Grid>
  );
};

Component.displayName = NAME_SUMMARY;

Component.propTypes = {
  approvalSubform: PropTypes.object.isRequired,
  css: PropTypes.object.isRequired,
  isRequest: PropTypes.bool,
  isResponse: PropTypes.bool
};
export default Component;
