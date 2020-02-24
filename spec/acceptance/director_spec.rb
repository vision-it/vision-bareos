require 'spec_helper_acceptance'

describe 'vision_bareos::director' do
  context 'with defaults' do
    it 'run idempotently' do
      setup = <<-FILE
        # Workaround for https://tickets.puppetlabs.com/browse/MODULES-5991
        package {'dirmngr': ensure => present}
        # Manually start with init, since we aint got so systemd
        if($facts[os][distro][codename] == 'stretch') {
         $p = 'mysql-server'
        } else {
         $p = 'mariadb-server'
        }
        package { $p:
          ensure => present,
        }->
          exec { '/bin/cp -p /etc/init.d/mysql /etc/init.d/mariadb':
        }->
          exec { '/bin/bash /etc/init.d/mysql start':
        }
      FILE
      apply_manifest(setup, accept_all_exit_codes: true, catch_failures: false)

      pp = <<-FILE
          # Fixture
          file{['/storage', '/storage/backups']:
            ensure => directory,
          }

        class { 'vision_bareos':
         type => 'director',
        }
      FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  # Director
  context 'director files provisioned' do
    describe file('/etc/bareos') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-dir.d/fileset') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-dir.d/client') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-dir.d/jobdefs') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-dir.d/schedule') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-dir.d/job') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-dir.d/storage') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-dir.d/job/Default-RestoreJob.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'Default-RestoreJob-job' }
    end
    describe file('/etc/bareos/bareos-dir.d/jobdefs/DefaultJob.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'LinuxDefault' }
    end
    describe file('/etc/bareos/bareos-dir.d/schedule/WeeklyCycle.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'WeeklyCycle' }
    end
    describe file('/etc/bareos/bareos-dir.d/fileset/LinuxDefault.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'LinuxDefault' }
      its(:content) { is_expected.to match 'backup-fileset' }
    end
    describe file('/etc/bareos/bareos-dir.d/storage/DefaultStorage.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'sd_host' }
    end
    describe file('/etc/bareos/bconsole.conf') do
      it { is_expected.to be_file }
    end
  end

  # Director Client Config
  context 'client config on director' do
    describe file('/etc/bareos/bareos-dir.d/client/barfoo.local.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'barfoo' }
      its(:content) { is_expected.to match 'secret2' }
      its(:content) { is_expected.to match 'TLS' }
    end
    describe file('/etc/bareos/bareos-dir.d/client/foobar.local.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'foobar' }
      its(:content) { is_expected.to match 'secret1' }
      its(:content) { is_expected.to match 'TLS' }
    end
    describe file('/etc/bareos/bareos-dir.d/job/barfoo.local.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'Enabled = "yes"' }
    end
    describe file('/etc/bareos/bareos-dir.d/job/foobar.local.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'Enabled = "no"' }
    end
  end

  # Storage Daemon
  context 'storage files provisioned' do
    describe file('/etc/bareos') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-sd.d/director/dir_host.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/etc/bareos/bareos-sd.d/messages/Standard.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/etc/bareos/bareos-sd.d/device/LocalFile.conf') do
      it { is_expected.to be_file }
    end
    describe file('/etc/bareos/bareos-sd.d/device/FileServer.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match '/mnt/fileserver' }
    end
  end

  # Storage Daemon
  context 'storage files provisioned' do
    describe file('/etc/bareos') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/bareos/bareos-sd.d/director/dir_host.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/etc/bareos/bareos-sd.d/messages/Standard.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/etc/bareos/bareos-sd.d/device/LocalFile.conf') do
      it { is_expected.to be_file }
    end
    describe file('/etc/bareos/bareos-sd.d/device/FileServer.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match '/mnt/fileserver' }
    end
  end

  # Lint Config
  context 'config files lint' do
    describe command('/usr/sbin/bareos-fd -t') do
      its(:exit_status) { is_expected.to eq 0 }
    end
    describe command('/usr/sbin/bareos-sd') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
