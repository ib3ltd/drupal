require 'yaml'

path = "#{File.dirname(__FILE__)}"
settings = YAML::load(File.read(path + '/vagrant-config.yaml'))

if File.exist?(path + '/vagrant-config-local.yaml')
    settings = settings.merge YAML::load(File.read(path + '/vagrant-config-local.yaml'))
end

Vagrant.configure(2) do |config|

    # General settings
    config.vm.define settings["name"]
    config.vm.box = settings["box"]
    config.vm.box_url = settings["box_url"]
    config.vm.box_download_checksum = settings["box_download_checksum"]
    config.vm.box_download_checksum_type = settings["box_download_checksum_type"]
    config.vm.hostname = settings["hostname"]
    config.vm.network "private_network", ip: settings["ip"] ||= "192.168.33.10"

    if settings.has_key?("public_ip")
      config.vm.network "public_network", ip: settings["public_ip"]
    end

    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Synced folders
    # Reorder folders for winnfsd plugin compatilibty see https://github.com/GM-Alex/vagrant-winnfsd/issues/12#issuecomment-78195957
    settings["folders"].sort! { |a,b| File.expand_path(a["map"]).length <=> File.expand_path(b["map"]).length }
    settings["folders"].each do |folder|
        config.vm.synced_folder folder["map"], folder["to"], settings["sync_options"]
    end

    # Apache configuration
    settings["sites"].each do |site|
        config.vm.provision "shell" do |s|
            s.inline = "bash /vagrant/serve.sh $1 $2"
            s.args = [site["map"], site["to"]]
        end
    end

    # Databases and users
    settings["databases"].each do |db|
        config.vm.provision "shell" do |s|
            s.inline = "bash /vagrant/database.sh $1 $2 $3 $4"
            s.args = [settings["dbrootpass"], db["name"], db["username"], db["password"]]
        end
    end
end