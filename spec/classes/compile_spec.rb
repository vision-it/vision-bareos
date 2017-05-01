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

      let :pre_condition do
        [
          'class vision_bareos::repo () {}'
        ]
      end

      context 'include client' do
        let :params do
          {
            type: 'client'
          }
        end
        it { is_expected.to contain_class('vision_bareos::client') }
      end

      context 'include director' do
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
        it { is_expected.to contain_class('vision_bareos::storage') }
        it { is_expected.to contain_class('vision_bareos::director') }
      end
    end
  end
end
