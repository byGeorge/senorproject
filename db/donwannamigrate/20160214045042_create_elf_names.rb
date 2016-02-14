class CreateElfNames < ActiveRecord::Migration
  def change
    create_table :elf_names do |t|

      t.timestamps null: false
    end
  end
end
