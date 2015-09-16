# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "sreenivas"
client_key               "#{current_dir}/sreenivas.pem"
validation_client_name   "rani-validator"
validation_key           "#{current_dir}/rani-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/rani"
cookbook_path            ["#{current_dir}/../cookbooks"]
