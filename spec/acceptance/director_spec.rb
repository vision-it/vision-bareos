require 'spec_helper_acceptance'

describe 'vision_bareos Director' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE

          # For Config Lint
          package{['bareos-director', 'bareos-storage']:
            ensure => present,
          }

          # Fixture
          file{['/storage', '/storage/backups']:
            ensure => directory,
          }

        class vision_docker () {}
        class vision_kerberos::client () {}

        class vision_bareos::director::database () {}
        class vision_bareos::director::images () {}
        class vision_bareos::director::run () {}
        class vision_bareos::storage::images () {}
        class vision_bareos::storage::run () {}
        class vision_bareos::webui::images () {}
        class vision_bareos::webui::run () {}

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
    describe file('/data/bareos') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/director') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/director/bareos-dir.d/fileset') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/director/bareos-dir.d/client') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/director/bareos-dir.d/jobdefs') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/director/bareos-dir.d/schedule') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/director/bareos-dir.d/job') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/director/bareos-dir.d/storage') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/director/bareos-dir.d/job/Default-RestoreJob.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'Default-RestoreJob-job' }
    end
    describe file('/data/bareos/director/bareos-dir.d/jobdefs/DefaultJob.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'LinuxDefault' }
    end
    describe file('/data/bareos/director/bareos-dir.d/schedule/WeeklyCycle.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'WeeklyCycle' }
    end
    describe file('/data/bareos/director/bareos-dir.d/fileset/LinuxDefault.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'LinuxDefault' }
      its(:content) { is_expected.to match 'backup-fileset' }
    end
    describe file('/data/bareos/director/bareos-dir.d/director/dir_host.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/data/bareos/director/bareos-dir.d/storage/DefaultStorage.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'sd_host' }
    end
    describe file('/data/bareos/director/bconsole.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
  end

  # Storage Daemon
  context 'storage files provisioned' do
    describe file('/data/bareos') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/storage') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/storage/bareos-sd.d/director/dir_host.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/data/bareos/storage/bareos-sd.d/storage/sd_host.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'DefaultStorage' }
    end
    describe file('/data/bareos/storage/bareos-sd.d/messages/Standard.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/data/bareos/storage/bareos-sd.d/device/LocalFile.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match '/mnt/local' }
    end
    describe file('/data/bareos/storage/bareos-sd.d/device/FileServer.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match '/mnt/fileserver' }
    end
  end

  # Storage Daemon
  context 'storage files provisioned' do
    describe file('/data/bareos') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/storage') do
      it { is_expected.to be_directory }
    end
    describe file('/data/bareos/storage/bareos-sd.d/director/dir_host.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/data/bareos/storage/bareos-sd.d/storage/sd_host.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'DefaultStorage' }
    end
    describe file('/data/bareos/storage/bareos-sd.d/messages/Standard.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'dir_host' }
    end
    describe file('/data/bareos/storage/bareos-sd.d/device/LocalFile.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match '/mnt/local' }
    end
    describe file('/data/bareos/storage/bareos-sd.d/device/FileServer.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match '/mnt/fileserver' }
    end
  end

  # # NFS Config
  # context 'nfs configured' do
  #   describe package('nfs-common') do
  #     it { is_expected.to be_installed }
  #   end
  #   describe file('/etc/fstab') do
  #     it { is_expected.to be_file }
  #     its(:content) { is_expected.to match 'fileserver' }
  #   end
  #   describe file('/storage/backups/fileserver') do
  #     it { is_expected.to be_directory }
  #   end
  # end

  # Lint Config
  context 'config files lint' do
    describe command('/usr/sbin/bareos-fd -t') do
      its(:exit_status) { is_expected.to eq 0 }
    end
    # TODO: Disabled until fixed
    # describe command('/usr/sbin/bareos-dir -t /data/bareos/director') do
    #   its(:exit_status) { is_expected.to eq 0 }
    # end
    describe command('/usr/sbin/bareos-sd -t /data/bareos/storage') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
