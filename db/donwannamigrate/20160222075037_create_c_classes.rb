class CreateCClasses < ActiveRecord::Migration
  def change
    create_table :c_classes do |t|

      t.timestamps null: false
    end
  end
end
