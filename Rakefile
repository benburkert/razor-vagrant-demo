require 'rake'
require 'net/ssh'
require 'net/scp'

USER = PASSWORD = 'vagrant'
HOSTS = {
  'gold' => '172.16.0.2',
}

def ssh(host, user = USER, password = PASSWORD)
  (@ssh_connections ||= {})[host.to_s] ||= begin
                                             Net::SSH.start(HOSTS[host.to_s], user, :password => password)
                                           end
end

def scp(host, local_path, remote_path, user = USER, password = PASSWORD)
  ssh(host, user, password).scp.upload!(local_path, remote_path)
end

def razor(*a)
  puts ssh(:gold).exec!(['sudo /opt/razor/bin/razor', *a].join(' '))
end

def download(options)
  url = options[:url]
  file_name = options[:as] || File.basename(url)
  folder = options[:to] || "."

  file_path = folder + "/" + file_name

  command = "curl #{url} -o #{file_path}"
  if File.exists?(file_path)
    puts "File #{file_path} already exists. skipping download!"
  else
    system(command) or raise "Download command failed: #{command}"
  end
end


namespace :microkernel do

  url = 'https://github.com/downloads/puppetlabs/Razor/rz_mk_dev-image.0.8.9.0.iso'
  file_name = File.basename(url)
  remote_file_name = "/tmp/#{file_name}"

  file file_name do
    download(:url => url)
  end

  task :upload => file_name do
    scp(:gold, file_name, remote_file_name)
  end

  task :setup => :upload do
    razor('image', 'add', 'mk', remote_file_name)
  end
end

task :microkernel => 'microkernel:setup'

namespace :ubuntu do

  url = 'http://releases.ubuntu.com/precise/ubuntu-12.04-server-amd64.iso'
  file_name = File.basename(url)
  remote_file_name = "/tmp/#{file_name}"

  file file_name do
    download(:url => url)
  end

  task :upload => file_name do
    scp(:gold, file_name, remote_file_name)
  end

  task :setup => :upload do
    razor('image', 'add', 'os', remote_file_name, 'ubuntu_precise', '12.04')
  end
end

task :ubuntu => 'ubuntu:setup'
