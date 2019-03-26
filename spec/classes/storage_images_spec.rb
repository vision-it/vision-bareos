require 'spec_helper'
require 'hiera'

describe 'vision_bareos::storage::images' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:pre_condition) { 'include vision_docker' }

      let(:params) do
        {
          storage_daemon_version: '1.2.3'
        }
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'contains' do
        it { is_expected.to contain_docker__image('bareos-storage').with_image_tag('1.2.3') }
      end
    end
  end
end
