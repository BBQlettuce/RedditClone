class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs do |t|
      t.string :Post

      t.timestamps null: false
    end
  end
end
