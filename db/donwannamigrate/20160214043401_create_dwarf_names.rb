class CreateDwarfNames < ActiveRecord::Migration
  def change
    create_table :dwarf_names do |t|

      t.timestamps null: false
    end
  end
end
