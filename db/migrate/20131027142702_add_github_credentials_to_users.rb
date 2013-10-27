class AddGithubCredentialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_user, :string
    add_column :users, :github_password, :string
  end
end
