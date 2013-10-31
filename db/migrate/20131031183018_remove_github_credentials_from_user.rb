class RemoveGithubCredentialsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :github_user
    remove_column :users, :github_password
  end

  def down
    add_column :users, :github_password, :string
    add_column :users, :github_user, :string
  end
end
