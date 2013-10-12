class CreateSessionLogs < ActiveRecord::Migration
  def change
    create_table :session_logs do |t|
      t.integer :user_id, :null => false
      t.string :remote_ip, :null => false
      t.string :location, :null => false
      t.string :user_agent, :null => false
      t.string :status, :null => false

      t.timestamps
    end

    add_index :session_logs, [:user_id]
  end
end
