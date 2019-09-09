require 'spec_helper_acceptance'

describe 'vision_bareos Director' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE

          # Fixture
          file{['/storage', '/storage/backups']:
            ensure => directory,
          }

        class { 'vision_bareos':
         type => 'director',
        }
      FILE

      apply_manifest(pp, catch_failures: false)
      apply_manifest(pp, catch_changes: false)
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
    # TODO: Disabled until fixed
    # describe command('/usr/sbin/bareos-dir -t /data/bareos/director') do
    #   its(:exit_status) { is_expected.to eq 0 }
    # end
    # describe command('/usr/sbin/bareos-sd -t /data/bareos/storage') do
    #   its(:exit_status) { is_expected.to eq 0 }
    # end
  end
end
