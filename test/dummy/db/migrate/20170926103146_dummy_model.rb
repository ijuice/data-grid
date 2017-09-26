class DummyModel < ActiveRecord::Migration[5.1]
  def change
    create_table :dummy_records do |t|
      t.string :name
      t.text :content
      t.boolean :is_true
    end
  end
end
