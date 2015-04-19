module LeanTag
  class Tag < ActiveRecord::Base

    self.table_name = :tags

    has_many :records, through: :taggings
    has_many :taggings, class_name: "LeanTag::Tagging", inverse_of: :tag

    scope :ranked, -> { order("taggings_count DESC") }

    validates :name, presence: true, uniqueness: true

    def name=(value)
      if value.present?
        self[:name] = value.gsub(/[^0-9a-zA-Z]+/, "")
        self[:name] = self[:name].downcase if LeanTag.config.force_lowercase
      end
    end

  end
end
