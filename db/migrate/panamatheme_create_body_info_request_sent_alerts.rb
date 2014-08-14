class PanamaThemeCreateBodyInfoRequestSentAlerts < ActiveRecord::Migration
  def self.change
    create_table :body_info_request_sent_alerts do |t|
      t.references :public_body
      t.references :info_request
      t.string :alert_type
      t.references :info_request_event

      t.timestamps
    end
    add_index :body_info_request_sent_alerts, :public_body_id
    add_index :body_info_request_sent_alerts, :info_request_id
    add_index :body_info_request_sent_alerts, :info_request_event_id
  end
end
