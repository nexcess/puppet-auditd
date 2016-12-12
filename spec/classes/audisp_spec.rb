require 'spec_helper'

describe 'auditd::audisp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      context 'with defaults' do
        let(:params) {{ :manage => true }}
        it { should contain_class('auditd::audisp::install').
             that_comes_before('Class[auditd::audisp::config]') }
        it { should contain_class('auditd::audisp::config') }
      end

      context 'with manage overridden' do
        let(:params) {{ :manage => false }}
        it { should_not contain_class('auditd::audisp::install') }
        it { should_not contain_class('auditd::audisp::config') }
      end

      describe 'auditd::audisp::install' do
        let(:params) {{ :install_plugins => true,
                        :plugin_package_name => 'audispd-plugins' }}

        context 'with defaults' do
          it { should contain_package('audispd-plugins') }
        end

        context 'with install_plugins overridden' do
          let(:params) {{ :install_plugins => false }}
          it { should_not contain_package('audispd-plugins') }
        end

        context 'with plugin_package_name overridden' do
          let(:params) {{ :plugin_package_name => 'foo' }}
          it { should contain_package('foo') }
        end
      end

      describe 'auditd::audisp::config' do
        let(:params) {{ :audispd_conf => '/etc/audisp/audispd.conf' }}

        context 'with defaults' do
          it { should contain_file('/etc/audisp/audispd.conf') }
          it { should contain_exec('reload auditd') }
        end

        context 'with audispd_conf overridden' do
          let(:params) {{ :audispd_conf => '/etc/mydir/foo.conf' }}
          it { should contain_file('/etc/mydir/foo.conf') }
        end
      end

      describe 'auditd::audisp::plugins' do
        let(:params) {{ :plugins => {} }}

        context 'with defaults' do
          it { is_expected.not_to contain_auditd__audisp__plugin('syslog') }
        end

        context 'with enabled plugins' do
          let :params do {
            :plugins => {
              'syslog' => { 'active'    => true,
                            'direction' => 'out',
                            'path'      => 'builtin_syslog',
                            'type'      => 'builtin',
                            'args'      => ['LOG_INFO'],
                            'format'    => 'string',
              },
            }
          }
          end
          it { is_expected.to contain_auditd__audisp__plugin('syslog') }
        end
      end

    end
  end
end
