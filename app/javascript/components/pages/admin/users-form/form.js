import { fromJS } from "immutable";
import * as yup from "yup";

import {
  FieldRecord,
  FormSectionRecord,
  TICK_FIELD,
  TEXT_FIELD,
  SELECT_FIELD,
  CHECK_BOX_FIELD
} from "../../../form";

export const validations = (formMode, i18n, useIdentityProviders, providers) => {
  const validations = {
    agency_id: yup
      .number()
      .required()
      .label(i18n.t("user.organization")),
    email: yup
      .string()
      .required()
      .label(i18n.t("user.email")),
    full_name: yup
      .string()
      .required()
      .label(i18n.t("user.full_name")),
    location: yup
      .string()
      .required()
      .label(i18n.t("user.location")),
    role_unique_id: yup
      .string()
      .required()
      .label(i18n.t("user.role_id")),
    user_group_unique_ids: yup
      .array()
      .required()
      .label(i18n.t("user.user_group_unique_ids"))
  };

  if (useIdentityProviders && providers) {
    validations.identity_provider_id = yup.number().required();

    const isIdpProvider = function(ref, message) {
      return this.test( "isIdpProvider", message, function (value) {
        const providerId = this.resolve(ref);
        const provider = providers.find(
          currentProvider => currentProvider.get("id") === parseInt(providerId, 10)
        );

        if (provider) {
          const regexMatch = new RegExp(`@${provider.get("user_domain")}$`);

          return value.match(regexMatch);
        }
      });
    };

    yup.addMethod(yup.string, "isIdpProvider", isIdpProvider);

    validations.user_name = yup
      .string()
      .isIdpProvider(yup.ref("identity_provider_id"))
      .required();
  } else {
    validations.password = yup.lazy(() => {
      const defaultValidation = yup.string().min(8);

      if (formMode.get("isNew")) {
        return defaultValidation.required().label(i18n.t("user.password"));
      }

      return defaultValidation;
    });
    validations.password_confirmation = yup.lazy(() => {
      const defaultValidation = yup
        .string()
        .oneOf(
          [yup.ref("password"), null],
          i18n.t("errors.models.user.password_mismatch")
        );

      if (formMode.get("isNew")) {
        return defaultValidation
          .required()
          .label(i18n.t("user.password_confirmation"));
      }

      return defaultValidation;
    });
    validations.user_name = yup.string()
      .required()
      .label(i18n.t("user.user_name"));
  }

  return yup.object().shape(validations);
};

export const form = ({
  i18n,
  formMode,
  useIdentityProviders,
  providers,
  roleOptions,
  identityOptions
}) => {
  let formData;

  if (useIdentityProviders && providers) {
    const identityOptions = providers.toJS().map(provider => {
      return { id: provider.id, display_text: provider.name };
    });

    const providersDisable = input => {
      return input === null;
    };

    formData = {
      unique_id: "users",
      fields: [
        FieldRecord({
          display_name: i18n.t("user.identity_provider"),
          name: "identity_provider_id",
          type: SELECT_FIELD,
          disabled: true,
          required: true,
          editable: false,
          option_strings_text: identityOptions
        }),
        FieldRecord({
          display_name: i18n.t("user.full_name"),
          name: "full_name",
          type: "text_field",
          required: true,
          autoFocus: true,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.user_name"),
          name: "user_name",
          disabled: true,
          type: TEXT_FIELD,
          required: true,
          editable: false,
          watchInput: "identity_provider_id",
          helpTextIfWatch: input => {
            const provider = providers
              ? providers.find(currentProvider => currentProvider.get("id") === parseInt(input, 10))
              : null;

            return provider
              ? i18n.t("user.provider_username_help", {
                domain: provider.get("user_domain")
              })
              : null;
          },
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.code"),
          name: "code",
          type: TEXT_FIELD,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.locale"),
          name: "locale",
          type: SELECT_FIELD,
          option_strings_text: i18n.applicationLocales.toJS(),
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.role_id"),
          name: "role_unique_id",
          type: SELECT_FIELD,
          required: true,
          option_strings_text: roleOptions,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.user_group_unique_ids"),
          name: "user_group_unique_ids",
          type: CHECK_BOX_FIELD,
          required: true,
          option_strings_text: [
            { id: "usergroup-primero-cp", display_text: "Primero CP" },
            { id: "usergroup-primero-ftf", display_text: "Primero FTR" },
            { id: "usergroup-primero-gbv", display_text: "Primero GBV" }
          ],
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.phone"),
          name: "phone",
          type: TEXT_FIELD,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.email"),
          name: "email",
          required: true,
          type: TEXT_FIELD,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.organization"),
          name: "agency_id",
          type: SELECT_FIELD,
          required: true,
          option_strings_text: [{ id: "1", display_text: "UNICEF" }],
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.agency_office"),
          name: "agency_office",
          type: TEXT_FIELD,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.position"),
          name: "position",
          type: TEXT_FIELD,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.location"),
          name: "location",
          type: SELECT_FIELD,
          option_strings_source: "Location",
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable,
          required: true
        }),
        FieldRecord({
          display_name: i18n.t("user.disabled"),
          name: "disabled",
          type: TICK_FIELD,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        }),
        FieldRecord({
          display_name: i18n.t("user.send_mail"),
          name: "send_mail",
          type: TICK_FIELD,
          watchDisableInput: "identity_provider_id",
          watchDisable: providersDisable
        })
      ]
    };
  } else {
    formData = {
      unique_id: "users",
      fields: [
        FieldRecord({
          display_name: i18n.t("user.full_name"),
          name: "full_name",
          type: "text_field",
          required: true,
          autoFocus: true
        }),
        FieldRecord({
          display_name: i18n.t("user.user_name"),
          name: "user_name",
          disabled: true,
          type: TEXT_FIELD,
          required: true,
          editable: false
        }),
        FieldRecord({
          display_name: i18n.t("user.code"),
          name: "code",
          type: TEXT_FIELD
        }),
        FieldRecord({
          display_name: i18n.t("user.password"),
          name: "password",
          type: TEXT_FIELD,
          password: true,
          hideOnShow: true,
          required: formMode.get("isNew")
        }),
        FieldRecord({
          display_name: i18n.t("user.password_confirmation"),
          name: "password_confirmation",
          type: TEXT_FIELD,
          password: true,
          hideOnShow: true,
          required: formMode.get("isNew")
        }),
        FieldRecord({
          display_name: i18n.t("user.locale"),
          name: "locale",
          type: SELECT_FIELD,
          option_strings_text: i18n.applicationLocales.toJS()
        }),
        FieldRecord({
          display_name: i18n.t("user.role_id"),
          name: "role_unique_id",
          type: SELECT_FIELD,
          required: true,
          option_strings_text: roleOptions
        }),
        FieldRecord({
          display_name: i18n.t("user.user_group_unique_ids"),
          name: "user_group_unique_ids",
          type: CHECK_BOX_FIELD,
          required: true,
          option_strings_text: [
            { id: "usergroup-primero-cp", display_text: "Primero CP" },
            { id: "usergroup-primero-ftf", display_text: "Primero FTR" },
            { id: "usergroup-primero-gbv", display_text: "Primero GBV" }
          ]
        }),
        FieldRecord({
          display_name: i18n.t("user.phone"),
          name: "phone",
          type: TEXT_FIELD
        }),
        FieldRecord({
          display_name: i18n.t("user.email"),
          name: "email",
          required: true,
          type: TEXT_FIELD
        }),
        FieldRecord({
          display_name: i18n.t("user.organization"),
          name: "agency_id",
          type: SELECT_FIELD,
          required: true,
          option_strings_source: "Agency"
        }),
        FieldRecord({
          display_name: i18n.t("user.agency_office"),
          name: "agency_office",
          type: TEXT_FIELD
        }),
        FieldRecord({
          display_name: i18n.t("user.position"),
          name: "position",
          type: TEXT_FIELD
        }),
        FieldRecord({
          display_name: i18n.t("user.location"),
          name: "location",
          type: SELECT_FIELD,
          option_strings_source: "Location",
          required: true
        }),
        FieldRecord({
          display_name: i18n.t("user.disabled"),
          name: "disabled",
          type: TICK_FIELD
        }),
        FieldRecord({
          display_name: i18n.t("user.send_mail"),
          name: "send_mail",
          type: TICK_FIELD
        })
      ]
    };
  }

  return fromJS([
    FormSectionRecord(formData)
  ]);
};
