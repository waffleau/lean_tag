module LeanTag
  class Tag < ActiveRecord::Base

    has_many :records, through: :taggings
    has_many :taggings, class_name: "LeanTag::Tagging", inverse_of: :tag, counter_cache: true

    scope :ranked, -> { order("taggings_count DESC") }

    validates :name, presence: true, uniqueness: true

    def name=(value)
      self[:name] = value.present? ? value.gsub(/[^0-9a-zA-Z]+/, "").downcase : nil
    end

  end
end
