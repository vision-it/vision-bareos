require 'spec_helper'
require 'hiera'

describe 'vision_bareos' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(
          root_home: '/root'
        )
      end

      context 'compile director' do
        let :pre_condition do
          [
            'class vision_kerberos::client () {}'
          ]
        end

        let :params do
          {
            type: 'director'
          }
        end
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
