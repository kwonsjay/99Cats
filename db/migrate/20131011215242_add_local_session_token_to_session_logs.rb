class AddLocalSessionTokenToSessionLogs < ActiveRecord::Migration
  def change
    add_column :session_logs, :local_session_token, :string
    add_index :session_logs, [:local_session_token], :unique => true
  end
end
