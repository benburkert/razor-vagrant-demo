require 'rake'
require 'net/ssh'
require 'net/scp'

USER = PASSWORD = 'vagrant'
HOSTS = {
  'gold' => '172.16.0.2',
}

DISTROS = {
  'microkernel' => {
    :type => :mk,
    :url  => 'https://github.com/downloads/puppetlabs/Razor/rz_mk_dev-image.0.9.0.4.iso',
  },
  'ubuntu' => {
    :release => 'ubuntu_precise',
    :version => '12.04',
    :url     => 'http://releases.ubuntu.com/precise/ubuntu-12.04-server-amd64.iso',
  },
  'scientific' => {
    :release => 'scientific',
    :version => '6.2',
    :url     => 'http://ftp.scientificlinux.org/linux/scientific/6.2/x86_64/iso/SL-62-x86_64-2012-02-06-Install-DVD.iso',
  },
  'centos' => {
    :release => 'centos',
    :version => '6.2',
    :url     => 'http://mirror.metrocast.net/centos/6.2/isos/x86_64/CentOS-6.2-x86_64-minimal.iso',
  },
}

def ssh(host, user = USER, password = PASSWORD)
  (@ssh_connections ||= {})[host.to_s] ||= net_ssh(HOSTS[host.to_s], user, password)
end

def net_ssh(address, user, password)
  Net::SSH.start(address, user, :password => password)
end

def scp(host, local_path, remote_path, user = USER, password = PASSWORD)
  ssh(host, user, password).scp.upload!(local_path, remote_path)
end

def razor(*a)
  puts ssh(:gold).exec!(['sudo /opt/razor/bin/razor', *a].join(' '))
end

def download(url, options = {})
  file_name = options[:as] || File.basename(url)
  folder    = options[:to] || "."

  file_path = folder + "/" + file_name

  command = "curl #{url} -o #{file_path}"
  if File.exists?(file_path)
    puts "File #{file_path} already exists. skipping download!"
  else
    system(command) or raise "Download command failed: #{command}"
  end
end

desc "Start here. Provision & configure the Razor server."
task :start do
  sh('librarian-puppet install')
  sh('vagrant up')
end

DISTROS.each do |name, options|
  namespace name do
    url               = options[:url]
    file_name         = File.basename(url)
    remote_file_name  = "/tmp/#{file_name}"

    file file_name do
      download(url)
    end

    task :upload => file_name do
      scp(:gold, file_name, remote_file_name)
    end

    task :setup => :upload do
      if options[:type] == :mk
        razor('image', 'add', 'mk', remote_file_name)
      else
        razor('image', 'add', 'os', remote_file_name, options[:release], options[:version])
      end
    end
  end

  task name => "#{name}:setup"
end
