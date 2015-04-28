class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag, index: true
      t.references :record, polymorphic: true, index: true
      t.string :filter, null: false, default: "tags"
      t.timestamps null: false
    end

    add_index :taggings, [:record_type, :record_id, :filter]
  end
end
