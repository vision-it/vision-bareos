require 'spec_helper_acceptance'

describe 'vision_bareos Client' do
  context 'with defaults' do
    it 'run idempotently' do
      if os[:release].to_i == 8
        pp = <<-FILE
        class { 'vision_bareos::client': }
        FILE
      elsif os[:release].to_i == 9
        pp = <<-FILE
        class { 'vision_bareos::client':
         manage_repo => false,
        }
        FILE
      else
        abort("Unsupported OS: #{os[:family]} #{os[:release]}")
      end

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'packages installed' do
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
