class NoteShareToken < ActiveRecord::Migration
  def change
    add_column :notes, :share_token, :string
  end
end
