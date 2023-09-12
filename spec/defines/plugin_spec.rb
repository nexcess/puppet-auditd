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
      case facts[:os]["release"]["major"]
      when '6'
      when '7'
        it { is_expected.to contain_file('/etc/audisp/plugins.d/syslog.conf').
            with_content(/^active = yes$/) }
      else
        it { is_expected.to contain_file('/etc/audit/plugins.d/syslog.conf').
            with_content(/^active = yes$/) }
      end

    end
  end
end
