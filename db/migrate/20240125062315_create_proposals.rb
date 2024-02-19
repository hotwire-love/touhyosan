class CreateProposals < ActiveRecord::Migration[7.0]
  def change
    create_table :proposals do |t|
      t.string :user_name
      t.string :content
      t.references :pre_poll, null: false, foreign_key: true

      t.timestamps
    end
  end
end
