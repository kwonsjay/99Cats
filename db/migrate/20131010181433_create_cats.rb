class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.integer :age, :null => false
      t.string :birth_date, :null => false
      t.string :color, :null => false
      t.string :name, :null => false
      t.column :sex, "char(1)", :null => false
      t.timestamps
    end
  end
end
