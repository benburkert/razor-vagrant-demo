require 'spec_helper'
describe 'tftp', :type => :class do

  describe 'when deploying on debian' do
    let(:facts) { { :operatingsystem => 'Debian',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }

    it { should contain_file('/etc/default/tftpd-hpa') }
    it { should contain_package('tftpd-hpa') }
    it { should contain_service('tftpd-hpa').with({
      'hasstatus' => false,
      'provider'  => nil,
    }) }
  end

  describe 'when deploying on ubuntu' do
    let(:facts) { { :operatingsystem => 'ubuntu',
                    :path            => '/usr/local/bin:/usr/bin:/bin', } }

    it { should contain_package('tftpd-hpa') }
    it { should contain_file('/etc/default/tftpd-hpa') }
    it { should contain_service('tftpd-hpa').with({
      'hasstatus' => true,
      'provider'  => 'upstart',
    }) }
  end

end
