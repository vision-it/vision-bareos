require 'spec_helper'
require 'hiera'

describe 'vision_bareos::storage::run' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:pre_condition) { 'include vision_docker' }

      let(:params) do
        {
          storage_path: '/storage/backups',
          version: 'latest'
        }
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'contains' do
        it { is_expected.to contain_docker__run('bareos-storage') }
      end
    end
  end
end
