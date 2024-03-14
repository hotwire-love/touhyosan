class CreatePrePolls < ActiveRecord::Migration[7.0]
  def change
    create_table :pre_polls do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
