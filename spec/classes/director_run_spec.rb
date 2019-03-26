require 'spec_helper'
require 'hiera'

describe 'vision_bareos::director::run' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:pre_condition) { 'include vision_docker' }

      let(:params) do
        {
          environment: [],
          sql_password: 'sql_password',
          admin_mail: 'admin',
          smtp_hostname: 'smtpd',
          storage_hostname: 'storage_host',
          storage_password: 'storage_password',
          webui_password: 'webui',
          mysql_version: '1.2.3'
        }
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'contains' do
        it { is_expected.to contain_docker__run('bareos-director') }
      end
    end
  end
end
