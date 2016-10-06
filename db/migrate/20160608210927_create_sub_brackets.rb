class CreateSubBrackets < ActiveRecord::Migration
  def change
    create_table :sub_brackets do |t|
      t.references :tournaments, index: true, foreign_key: true
      t.integer :num

      t.timestamps null: false
    end
  end
end
