// Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

import { mountedComponent, screen } from "test-utils";

import { FieldRecord, FormSectionRecord } from "../../../records";
import { RECORD_TYPES_PLURAL } from "../../../../../config";

import SubformDialog from "./component";

describe("<SubformDialog />", () => {
  const props = {
    arrayHelpers: {},
    dialogIsNew: true,
    formik: { values: [], errors: {} },
    mode: { isEdit: true },
    initialSubformValue: {},
    index: 0,
    i18n: { t: value => value },
    open: true,
    setOpen: () => {},
    title: "Family details",
    formSection: {},
    violationOptions: []
  };

  describe("when is a family member", () => {
    const familyDetailsField = FieldRecord({
      name: "family_details_section",
      subform_section_id: FormSectionRecord({
        unique_id: "family_details_subform_section",
        fields: [
          FieldRecord({
            name: "relation_name",
            visible: true,
            type: "text_field"
          }),
          FieldRecord({
            name: "relation_age",
            visible: true,
            type: "text_field"
          })
        ]
      })
    });

    describe("when is show mode", () => {
      it("renders the Family Actions to create a case if a user can create cases", () => {
        mountedComponent(
          <SubformDialog
            {...props}
            recordType={RECORD_TYPES_PLURAL.case}
            field={familyDetailsField}
            mode={{ isShow: true }}
            isFamilyMember
          />,
          {
            user: { permissions: { cases: ["case_from_family"] } }
          }
        );

        expect(screen.queryByText("family.family_member.back_to_family_members")).toBeTruthy();
        expect(screen.queryByText("family.family_member.create_case")).toBeTruthy();
      });

      it("renders the Family Actions to create a case if a user can create cases from family", () => {
        mountedComponent(
          <SubformDialog
            {...props}
            recordType={RECORD_TYPES_PLURAL.family}
            field={familyDetailsField}
            mode={{ isShow: true }}
            isFamilyMember
          />,
          {
            user: { permissions: { families: ["case_from_family"] } }
          }
        );

        expect(screen.queryByText("family.family_member.back_to_family_members")).toBeTruthy();
        expect(screen.queryByText("family.family_member.create_case")).toBeTruthy();
      });

      it("renders the Family Actions without the create case action if the user does not have permission", () => {
        mountedComponent(
          <SubformDialog
            {...props}
            recordType={RECORD_TYPES_PLURAL.case}
            field={familyDetailsField}
            mode={{ isShow: true }}
            isFamilyMember
          />
        );

        expect(screen.queryByText("family.family_member.back_to_family_members")).toBeTruthy();
        expect(screen.queryByText("family.family_member.create_case")).toBeFalsy();
      });

      it("renders the Family Actions with a link to a case", () => {
        mountedComponent(
          <SubformDialog
            {...props}
            formik={{ values: { family_details_section: [{ case_id: "001", case_id_display: "001" }] }, errors: {} }}
            recordType={RECORD_TYPES_PLURAL.family}
            field={familyDetailsField}
            mode={{ isShow: true }}
            isFamilyMember
          />
        );

        expect(screen.queryByText("family.family_member.case_id")).toBeTruthy();
        expect(screen.queryByText("001")).toBeTruthy();
      });
    });

    describe("when is edit mode", () => {
      it("renders the Family Actions for edit mode", () => {
        mountedComponent(
          <SubformDialog {...props} field={familyDetailsField} mode={{ isEdit: true }} isFamilyMember />
        );

        expect(screen.queryByText("family.family_member.save_and_return")).toBeTruthy();
        expect(screen.queryByText("cancel")).toBeTruthy();
      });

      describe("and isReadWriteForm is false", () => {
        it("renders 'Back to Family Details' button", () => {
          mountedComponent(
            <SubformDialog
              {...props}
              field={familyDetailsField}
              mode={{ isEdit: true }}
              isFamilyDetail
              isReadWriteForm={false}
            />
          );

          expect(screen.queryByText("case.back_to_family_details")).toBeInTheDocument();
          expect(screen.queryByText("cancel")).not.toBeInTheDocument();
        });
      });
    });
  });
});
