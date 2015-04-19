module LeanTag
  class Tagging < ActiveRecord::Base

    self.table_name = :taggings

    belongs_to :record, polymorphic: true, inverse_of: :taggings
    belongs_to :tag, class_name: "LeanTag::Tag", inverse_of: :taggings

    validates :record_id, presence: true
    validates :record_type, presence: true
    validates :tag, presence: true, uniqueness: { scope: [:record_type, :record_id] }

  end
end
