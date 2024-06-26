// Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

import { Card, CardHeader, CardContent } from "@material-ui/core";
import { Link } from "react-router-dom";
import PropTypes from "prop-types";

import LoadingIndicator from "../../loading-indicator";
import DisableOffline from "../../disable-offline";
import { ConditionalWrapper } from "../../../libs";

import css from "./styles.css";

const OptionsBox = ({ title, action, children, to, flat, overlay, type, loading, errors, hasData }) => {
  const loadingIndicatorProps = {
    overlay,
    type,
    loading,
    errors,
    hasData
  };

  const cardTitle = title && (
    <CardHeader
      action={action}
      title={
        to ? (
          <Link to={to} className={css.cardLink}>
            {title}
          </Link>
        ) : (
          <h4>{title}</h4>
        )
      }
      className={css.title}
    />
  );

  return (
    <Card className={!flat && css.card} elevation={flat ? 0 : 3}>
      <ConditionalWrapper condition={!flat} wrapper={DisableOffline}>
        <>
          {cardTitle}
          <LoadingIndicator {...loadingIndicatorProps}>
            <CardContent className={css.content}>{children}</CardContent>
          </LoadingIndicator>
        </>
      </ConditionalWrapper>
    </Card>
  );
};

OptionsBox.displayName = "OptionsBox";

OptionsBox.defaultProps = {
  hasData: true,
  type: ""
};

OptionsBox.propTypes = {
  action: PropTypes.node,
  children: PropTypes.node,
  errors: PropTypes.bool,
  flat: PropTypes.bool,
  hasData: PropTypes.bool,
  loading: PropTypes.bool,
  overlay: PropTypes.bool,
  title: PropTypes.string,
  to: PropTypes.node,
  type: PropTypes.string
};

export default OptionsBox;
