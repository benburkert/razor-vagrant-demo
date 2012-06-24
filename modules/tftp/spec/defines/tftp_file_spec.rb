require 'spec_helper'

describe 'tftp::file' do

  let(:title) { 'sample' }

  describe 'when deploying on debian' do
    let(:facts) { { :operatingsystem => 'Debian',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }

    it { should include_class('tftp') }
    it { should contain_file('/srv/tftp/sample').with({
      'ensure' => 'file',
      'owner'  => 'tftp',
      'group'  => 'tftp',
      'mode'   => '0644'
    }) }
  end

  describe 'when deploying on ubuntu' do
    let(:facts) { { :operatingsystem => 'ubuntu',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }

    it { should include_class('tftp') }
    it { should contain_file('/var/lib/tftpboot/sample').with({
      'ensure' => 'file',
      'owner'  => 'tftp',
      'group'  => 'tftp',
      'mode'   => '0644'
    }) }
  end

  describe 'when deploying with parameters' do
    let(:params) { {:ensure => 'directory',
                    :owner  => 'root',
                    :group  => 'root',
                    :mode   => '0755' }}
    let(:facts) { { :operatingsystem => 'Debian',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }

    it { should include_class('tftp') }
    it { should contain_file('/srv/tftp/sample').with({
      'ensure' => 'directory',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0755'
    }) }
  end
end
