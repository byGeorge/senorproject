class CreateElfSyllables < ActiveRecord::Migration
  def change
    create_table :elf_syllables do |t|

      t.timestamps null: false
    end
  end
end
