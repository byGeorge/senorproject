class CreateHumanNames < ActiveRecord::Migration
  def change
    create_table :human_names do |t|

      t.timestamps null: false
    end
  end
end
