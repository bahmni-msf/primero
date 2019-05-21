class Agency < ApplicationRecord

  # include Memoizable #TODO: We may pull this out or have a more polite way of caching
  include LocalizableJsonProperty
  include Configuration

  LOGO_DIMENSION = {
    logo_large: { width: 512, height: 512 },
    logo_small: { width: 72, height: 72 }
  }

  localize_properties :name, :description

  validates :agency_code, presence: { message: 'errors.models.agency.code_present' }
  validate :validate_name_in_english

  has_one_attached :logo_large
  has_one_attached :logo_small


  validates :logo_large, file_size: { less_than_or_equal_to: 10.megabytes },
                         file_content_type: { allow: 'image/png' }, if: -> { logo_large.attached? }
  validates :logo_small, file_size: { less_than_or_equal_to: 10.megabytes },
                         file_content_type: { allow: 'image/png' }, if: -> { logo_small.attached? }

  validate :validate_logo_large_dimension
  validate :validate_logo_small_dimension



  class << self
    alias :old_all :all
    alias :by_all :all
    alias :list_by_all :all

    def all
      old_all
    end
    # memoize_in_prod :all
    # memoize_in_prod :list_by_all

    #TODO: Consider moving this to a shared concern
    def enabled(is_enabled=true)
      where(disabled: !is_enabled)
    end

    #This method returns a list of id / display_text value pairs
    #It is used to create the select options list for Agency fields
    def all_names
      enabled.map{|r| {id: r.id, display_text: r.name}.with_indifferent_access}
    end
    # memoize_in_prod :all_names

    # This method must be refactored
    def retrieve_logo_ids
      Agency.where(logo_enabled: true).map(&:logo_small)
    end
    # memoize_in_prod :retrieve_logo_ids

    def display_text(agency_id, opts={})
      locale = (opts[:locale].present? ? opts[:locale] : I18n.locale)
      agency = Agency.find_by_id(agency_id)
      value = (agency.present? ? agency.name(locale) : '')
    end
    # memoize_in_prod :display_text
  end

  private
  def validate_name_in_english
    return true if self.name_en.present?
    errors.add(:name, 'errors.models.agency.name_present')
    return false
  end

  def validate_logo_large_dimension
    validate_image_dimension('logo_large')
  end
  def validate_logo_small_dimension
    validate_image_dimension('logo_small')
  end

  def validate_image_dimension(type)
     width = send(type).try('metadata').try(:dig, 'width')
     height = send(type).try('metadata').try(:dig, 'height')

     valid_width = LOGO_DIMENSION[type.to_sym][:width]
     valid_height = LOGO_DIMENSION[type.to_sym][:height]
     return true if width.blank? || height.blank?
     if (width > valid_width || height > valid_height)
       errors.add(type.to_sym, I18n.t('errors.models.agency.logo_dimension', width: valid_width.to_s, height: valid_height.to_s))
       return false
     end
  end
end
