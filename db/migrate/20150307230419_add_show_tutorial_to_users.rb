class AddShowTutorialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_tutorial, :boolean, default: true
  end
end
