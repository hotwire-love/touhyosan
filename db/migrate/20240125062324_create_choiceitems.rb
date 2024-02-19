class CreateChoiceitems < ActiveRecord::Migration[7.0]
  def change
    create_table :choiceitems do |t|
      t.string :title
      t.boolean :accepted
      # t.references :pre_poll, null: false, foreign_key: true
      t.references :proposal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
