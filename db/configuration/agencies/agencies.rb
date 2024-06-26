# frozen_string_literal: true

# Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

# unicef = Agency.create_or_update!(
#   name_en: 'UNICEF',
#   agency_code: 'UNICEF',
#   unique_id: 'UNICEF'
# )
#
# unicef.logo_full.attach(
#   io: File.open("#{File.dirname(__FILE__)}/unicef-full.png"), filename: 'unicef-full.png'
# )
# unicef.logo_icon.attach(
#   io: File.open("#{File.dirname(__FILE__)}/unicef-icon.png"), filename: 'unicef-icon.png'
# )
# unicef.logo_enabled = true
# unicef.save!

msf = Agency.create_or_update!(
  name_en: 'MSF',
  agency_code: 'MSF',
  unique_id: 'MSF'
)

msf.logo_full.attach(
  io: File.open("#{File.dirname(__FILE__)}/msf-full.png"), filename: 'msf-full.png'
)
msf.logo_icon.attach(
  io: File.open("#{File.dirname(__FILE__)}/msf-full.png"), filename: 'msf-full.png'
)
msf.logo_enabled = true
msf.save!
