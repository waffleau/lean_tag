class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag, index: true
      t.references :record, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
