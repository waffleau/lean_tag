module LeanTag
  module Taggable

    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods

      base.class_eval do
        has_many :taggings, class_name: "LeanTag::Tagging", as: :record, inverse_of: :record, dependent: :destroy
        has_many :tags, through: :taggings

        accepts_nested_attributes_for :taggings, allow_destroy: true

        scope :with_tags, -> { includes(:tags) }
      end
    end


    module ClassMethods

      def tagged_in(list)
        list = list.split(LeanTag.config.delimiter) if list.is_a?(String)
        tag_ids = Tag.matches(list).pluck(:id)
        record_ids = Tagging.where(record_type: self.name, tag_id: tag_ids).pluck(:record_id).uniq
        return self.where(id: record_ids)
      end

      def tags
        tag_ids = Tagging.where(record_type: self.name).pluck(:tag_id).uniq
        return Tag.where(id: tag_ids)
      end

    end


    module InstanceMethods

      ##
      # Adds a single tag on parent save
      def add_tag(tag)
        if tag.is_a?(String)
          record = Tag.find_by_name(tag)
        end

        if record.nil?
          self.tags.build(name: tag)
        elsif !self.taggings.exists?(tag_id: record.id)@
          self.taggings.build(tag_id: record.id)
        end
      end

      ##
      # Adds a single tag immediately
      def add_tag!(tag)
        self.add_tag(tag)
        self.save!
      end

      ##
      # Finds current tags on this record which aren't in the passed list
      def excluded_tags(tag_names)
        self.tags.reject { |t| t.name.in?(tag_names) }
      end

      ##
      # Finds current tags on this record which are in the passed list
      def included_tags(tag_names)
        self.tags.select { |t| t.name.in?(tag_names) }
      end

      ##
      # Removes a single tag on parent save
      def remove_tag(tag)
        if tag.is_a?(String)
          tag = self.tags.where(name: tag).first
        end

        self.taggings.each { |t| t.mark_for_destruction if t.tag.eql?(tag) }
      end

      ##
      # Removes a single tag immediately
      def remove_tag!(tag)
        self.remove_tag(tag)
        self.save!
      end

      ##
      # Set a list of tags
      def tag_list=(value)
        if value.is_a?(String)
          tag_names = value.split(LeanTag.config.delimiter)
        elsif value.is_a?(Array)
          tag_names = value
        else
          tag_names = []
        end

        # Get rid of existing tags that aren't in the list
        self.excluded_tags(tag_names).each { |t| self.remove_tag(t) }

        # Add any new tags
        tag_names.each { |t| self.add_tag(t) }
      end

      ##
      # Returns a delimited list of tag names
      def tag_list
        self.tags.map(&:name).join(',')
      end

    end

  end
end
