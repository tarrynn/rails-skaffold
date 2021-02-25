class AddTable < ActiveRecord::Migration[6.1]
  def change
    create_table :test do |t|
      t.string :name
    end
  end
end
