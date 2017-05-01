require 'spec_helper'
require 'hiera'

describe 'vision_bareos' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(
          fqdn: 'rspec'
        )
      end

      context 'compile client' do
        let :pre_condition do
          [
            'class vision_bareos::repo () {}'
          ]
        end

        let :params do
          {
            type: 'client'
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          expect(exported_resources).to contain_vision_bareos__job('rspec').with(
                                          'client' => 'rspec',
                                          'tag'    => 'bareos_client_config'
                                        )
        end

        it do
          expect(exported_resources).to contain_file('rspec-bareos-client.conf').with(
                                         'ensure' => 'present',
                                         'mode'   => '0644',
                                         'tag'    => 'bareos_client_config'
                                        )
        end
      end
    end
  end
end
