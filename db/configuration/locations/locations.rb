# frozen_string_literal: true

# Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

# TODO: This is a temporary fake location set.
# Once we sort out a location management strategy, we will start using real locations.

puts 'Loading temporary locations!'

Location.destroy_all

# locations = [
#   Location.new(placename_en: 'Country 1', location_code: 'XX', admin_level: 0, type: 'country', hierarchy_path: 'XX'),
#   Location.new(placename_en: 'Province 1', location_code: 'XX01', admin_level: 1, type: 'province',
#                hierarchy_path: 'XX.XX01'),
#   Location.new(placename_en: 'District 1', location_code: 'XX0101', admin_level: 2, type: 'district',
#                hierarchy_path: 'XX.XX01.XX0101'),
#   Location.new(placename_en: 'District 2', location_code: 'XX0102', admin_level: 2, type: 'district',
#                hierarchy_path: 'XX.XX01.XX0102')
# ]

locations = [
  Location.new(placename_en: 'Libya',location_code: 'LB',admin_level: 0, type: 'country'),
  Location.new(placename_en: 'Paris',location_code: 'PRS',admin_level: 0, type: 'country')
]

Location.locations_by_code = locations.map { |l| [l.location_code, l] }.to_h

locations.each(&:name_from_hierarchy)

locations.each(&:save!)
