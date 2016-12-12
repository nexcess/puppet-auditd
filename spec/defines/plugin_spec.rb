require 'spec_helper'

describe 'auditd::audisp::plugin' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:title) { 'syslog' }
      let(:params) {{ :active    => true,
                      :direction => 'out',
                      :path      => 'builtin_syslog',
                      :type      => 'builtin',
                      :args      => ['LOG_INFO'],
                      :format    => 'string' }}
      
      it { is_expected.to contain_class('auditd::service') }
      it { is_expected.to contain_file('/etc/audisp/plugins.d/syslog.conf').
           with_content(/^active = yes$/) }

    end
  end
end
