class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag, index: true
      t.references :record, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_index [:record_type, :record_id, :filter]
  end
end
