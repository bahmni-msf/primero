import React from "react";
import { selectAgency } from "components/pages/login";
import { selectPrimeroModule } from "components/user";
import { Grid, Box, CssBaseline } from "@material-ui/core";
import { ModuleLogo } from "components/module-logo";
import { AgencyLogo } from "components/agency-logo";
import { ListIcon } from "components/list-icon";
import { TranslationsToggle } from "components/translations-toggle";
import { NavLink } from "react-router-dom";
import { useI18n } from "components/i18n";
import { makeStyles } from "@material-ui/styles";
import { useSelector } from "react-redux";
import PropTypes from "prop-types";
import { Notifier } from "components/notifier";
import styles from "./login-styles.css";

const LoginLayout = ({ children }) => {
  const css = makeStyles(styles)();
  const i18n = useI18n();

  const primeroModule =
    useSelector(state => selectPrimeroModule(state)) || "cp";
  const agency = useSelector(state => selectAgency(state));

  return (
    <div>
      <CssBaseline />
      <Notifier />
      <Box className={[css.primeroBackground, css[primeroModule]].join(" ")}>
        <div className={css.content}>
          <div className={css.loginHeader}>
            <ModuleLogo moduleLogo={primeroModule} white />
          </div>
          <div className={css.authContainer}>
            <div className={css.auth}>
              <div className={css.formContainer}>
                <div className={css.form}>{children}</div>
              </div>
              <div className={css.loginLogo}>
                <AgencyLogo agency={agency} />
              </div>
            </div>
          </div>
        </div>
        <Grid container className={css.footer}>
          <Grid item xs={2}>
            <TranslationsToggle />
          </Grid>
          <Grid item xs={8} />
          <Grid item xs={2}>
            <NavLink
              to="/support"
              className={css.navLink}
              activeClassName={css.navActive}
              exact
            >
              <ListIcon icon="support" />
              <span>{i18n.t("navigation.support")}</span>
            </NavLink>
          </Grid>
        </Grid>
      </Box>
    </div>
  );
};

LoginLayout.propTypes = {
  children: PropTypes.node
};

export default LoginLayout;