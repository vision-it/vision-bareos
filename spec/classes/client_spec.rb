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
        let :params do
          {
            type: 'client'
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
