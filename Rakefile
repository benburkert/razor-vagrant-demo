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

namespace :microkernel do

  url = 'https://github.com/downloads/puppetlabs/Razor/rz_mk_dev-image.0.8.9.0.iso'
  path = File.basename(url)
  remote_path = "/tmp/#{path}"

  file path do
    system("wget #{url}")
  end

  task :upload => path do
    scp(:gold, path, remote_path)
  end

  task :setup => :upload do
    razor('image', 'add', 'mk', remote_path)
  end
end

task :microkernel => 'microkernel:setup'

namespace :ubuntu do

  url = 'http://releases.ubuntu.com/precise/ubuntu-12.04-server-amd64.iso'
  path = File.basename(url)
  remote_path = "/tmp/#{path}"

  file path do
    system("wget #{url}")
  end

  task :upload => path do
    scp(:gold, path, remote_path)
  end

  task :setup => :upload do
    razor('image', 'add', 'os', remote_path, 'ubuntu_precise', '12.04')
  end
end

task :ubuntu => 'ubuntu:setup'
