module LeanTag
  module Taggable

    def self.extended(base)

      def taggable_on(relation="tags")
        extend ClassMethods

        self.class_exec(relation) do |tag_relation|
          include InstanceMethods

          has_many "#{tag_relation}_taggings".to_sym, -> { where(filter: tag_relation) }, class_name: "LeanTag::Tagging", as: :record, inverse_of: :record, dependent: :destroy
          has_many tag_relation.to_sym, through: "#{tag_relation}_taggings".to_sym, source: :tag

          accepts_nested_attributes_for "#{tag_relation}_taggings", allow_destroy: true

          scope "with_#{tag_relation}", -> { includes(tag_relation) }

          define_method "add_#{tag_relation.to_s.singularize}", ->(tag) { _add_tag(tag, tag_relation) }
          define_method "add_#{tag_relation.to_s.singularize}!", ->(tag) { _add_tag!(tag, tag_relation) }
          define_method "#{tag_relation.to_s.singularize}_list", ->() { _get_tag_list(tag_relation) }
          define_method "remove_#{tag_relation.to_s.singularize}", ->(tag) { _remove_tag(tag, tag_relation) }
          define_method "remove_#{tag_relation.to_s.singularize}!", ->(tag) { _remove_tag!(tag, tag_relation) }
          define_method "#{tag_relation.to_s.singularize}_list=", ->(list) { _set_tag_list(list, tag_relation) }
        end
      end

    end


    module ClassMethods

      ##
      # Returns all records which include at least one of the passed tags
      def tagged_with(list, filter="tags")
        list = list.split(LeanTag.config.delimiter) if list.is_a?(String)
        tag_ids = Tag.matches(list).pluck(:id)
        taggings = Tagging.where(record_type: self.name, tag_id: tag_ids).where(filter: filter)
        return self.where(id: taggings.select(:record_id).distinct)
      end


      ##
      # Get all tags used by this class
      def tags(filter="tags")
        taggings = Tagging.where(record_type: self.name, filter: filter).where(filter: filter)
        return Tag.where(id: taggings.select(:tag_id).distinct)
      end

    end


    module InstanceMethods

      ##
      # Adds a single tag on parent save
      def _add_tag(tag, filter="tags")
        if tag.is_a?(String)
          record = Tag.find_by_name(tag)
        end

        if record.nil?
          self._tags(filter).build(name: tag)
        elsif !self._taggings(filter).exists?(tag_id: record.id)
          self._taggings(filter).build(tag_id: record.id)
        end
      end

      ##
      # Adds a single tag immediately
      def _add_tag!(tag, filter="tags")
        self._add_tag(tag, filter)
        self.save!
      end

      ##
      # Returns a delimited list of tag names
      def _get_tag_list(filter="tags")
        self._taggings(filter).map(&:tag).map(&:name).join(',')
      end

      # Removes a single tag on parent save
      def _remove_tag(tag, filter="tags")
        if tag.is_a?(String)
          tag = Tag.find_by_name(tag)
        end

        self._taggings(filter).each { |t| t.mark_for_destruction if t.tag.eql?(tag) }
      end

      ##
      # Removes a single tag immediately
      def _remove_tag!(tag, filter="tags")
        self._remove_tag(tag, filter)
        self.save!
      end

      ##
      # Set a list of tags
      def _set_tag_list(list, filter="tags")
        if list.is_a?(String)
          tag_names = list.split(LeanTag.config.delimiter)
        elsif list.is_a?(Array)
          tag_names = list
        else
          tag_names = []
        end

        tags = Tag.where(id: self._taggings(filter).select(:tag_id).distinct)
        tags.reject { |t| t.name.in?(tag_names) }.each { |t| self._remove_tag(t, filter) }

        # Add any new tags
        tag_names.each { |t| self._add_tag(t, filter) }
      end

      ##
      # Gets relevant tag association
      def _tags(filter)
        self.send(filter)
      end

      ##
      # Gets relevant taggings association
      def _taggings(filter)
        self.send("#{filter}_taggings")
      end

    end

  end
end
