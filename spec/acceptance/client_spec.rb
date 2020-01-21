require 'spec_helper_acceptance'

describe 'vision_bareos::client' do
  context 'with defaults' do
    it 'run idempotently' do
      setup = <<-FILE
        # Workaround for https://tickets.puppetlabs.com/browse/MODULES-5991
        package {'dirmngr': ensure => present}
        package { 'bareos-client':
         ensure => 'present',
        }->
        exec { '/bin/cp -p /etc/init.d/bareos-fd /etc/init.d/bareos-filedaemon':
        }
      FILE
      apply_manifest(setup, accept_all_exit_codes: true, catch_failures: false)

      pp = <<-FILE
        class { 'vision_bareos::client':
        }
        FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'packages installed' do
    describe file('/etc/apt/sources.list.d/bareos.list') do
      it { is_expected.not_to exist }
    end

    describe package('bareos-filedaemon') do
      it { is_expected.to be_installed }
    end
  end

  context 'files provisioned' do
    describe file('/etc/bareos/bareos-fd.d/client/myself.conf') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match '[dD]ebian' }
    end
    describe file('/etc/bareos/bareos-fd.d/director/bareos-dir.conf') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'beaker' }
    end
  end
end
