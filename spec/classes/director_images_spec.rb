require 'spec_helper'
require 'hiera'

describe 'vision_bareos::director::images' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          director_version: '1.2.3',
          mysql_version: '1.2.3'
        }
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'contains' do
        it { is_expected.to contain_docker__image('bareos-director').with_image_tag('1.2.3') }
      end
    end
  end
end
