class MniData < ActiveRecord::Migration[5.1]
  def up
    add_column :organizations, :is_mni, :boolean, :default => false
    add_column :organizations_locations, :id, :primary_key

    execute <<-DDL
    CREATE TYPE mobile_services AS ENUM ('Airtime', 'API', 'HS', 'Mobile-Internet', 'Mobile-Money', 'Ops-Maintenance', 'OTT', 'SLA', 'SMS', 'User-Interface', 'USSD', 'Voice' );
    DDL

    execute <<-DDL
    CREATE TYPE agg_capabilities AS ENUM ('Transfer to Subscribers', 'Transfer to Business', 'Balance Check', 'Delivery Notification', 'Reporting',
      'SMPP', 'HTTP', 'HTTPS', 'XML-RPC', 'FTP', 'GUI-Self Service', 'Data Integrity', 'VPN', 'Other API Support',
      'Content Management', 'Subscription Management', 'Campaign Management', 'Portal Management', 'Recommendation Engine', 'Advertisement Platform', 'Analytics and Reporting',
      'URL-IP Configuration', 'Standard Billing', 'Zero Rated', 'Reverse Billing', 'Private APN Provisioning',
      'Business to Subscriber', 'Subscriber to Business', 'Bulk Transfer',
      'Alarm Support', 'Consolidated Reports', 'Automated realtime alerts', 'Configure & Monitor Message length', 'Threshold Monitoring', 'Spam Control',
      'WhatsApp', 'Facebook Messenger', 'Media Streaming',
      'Reliability percent', 'High Availability', 'Redundancy', 'Support', 'Security Policies', 
      'One Way', 'Two Way', 'Bulk SMS', 'Delivery Reports', 'Sender ID Configuration', 'Number Masking', 'Premium Billing', 'Zero Rating', 'Dedicated Short Code Provisioning', 'Shared Short Code', 'Long Code Provisioning', 'SMS Spam filter', 'Automated regulatory compliance', 'Traffic-Capacity-Bandwidth',
      'Graphical User Interface', 'Customized User Creation',
      'Session Reports', 'Hosted Menu',
      'IVR Inbound', 'IVR Outbound', 'Leased Lines', 'VOIP', 'Hosted IVR Menu', 'Short Code Provisioning');
    DDL

    create_table :operator_services do |t|
      t.string :name
      t.references :locations, foreign_key: true
    end

    add_column :operator_services, :service, :mobile_services
    add_index :operator_services, [:name, :locations_id, :service], unique: true

    create_table :aggregator_capabilities do |t|
      t.references :organization, foreign_key: true
      t.references :operator_services, foreign_key: true
    end

    rename_column :aggregator_capabilities, :organization_id, :aggregator_id
    add_column :aggregator_capabilities, :service, :mobile_services
    add_column :aggregator_capabilities, :capability, :agg_capabilities
    add_column :aggregator_capabilities, :country_name, :string
    add_index :aggregator_capabilities, [:aggregator_id, :operator_services_id, :capability], unique: true, :name => 'agg_cap_operator_capability_index'
    
  end

  def down
    drop_table :aggregator_capabilities
    drop_table :operator_services

    remove_column :organizations, :is_mni
    remove_column :organizations_locations, :id, :primary_key
    
    execute "DROP TYPE mobile_services;"
    execute "DROP TYPE agg_capabilities;"
  end
end
