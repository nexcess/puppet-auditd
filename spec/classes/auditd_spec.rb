require 'spec_helper'

describe 'auditd' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { should contain_class('auditd::install').
           that_comes_before('Class[auditd::config]') }
      it { should contain_class('auditd::config').
           that_comes_before('Class[auditd::rules]') }
      it { should contain_class('auditd::rules').
           that_comes_before('Class[auditd::service]') }
      it { should contain_class('auditd::service') }

      describe 'auditd::install' do
        let(:params) {{ :package_state => 'present', :package_name => 'audit',
                        :manage_package => true, }}
        it { should contain_package('audit').with(:ensure => 'present') }

        describe 'should allow package to be unmanaged' do
          let(:params) {{ :manage_package => false, :package_name => 'audit' }}
          it { should_not contain_package('audit') }
        end

        describe 'should allow package name to be overridden' do
          let(:params) {{ :package_name => 'foo', :manage_package => true,
                          :package_state => 'present' }}
          it { should contain_package('foo').with(:ensure => 'present') }
        end

        describe 'should allow package ensure to be overridden' do
          let(:params) {{ :package_state => 'latest', :package_name => 'audit',
                          :manage_package => true }}
          it { should contain_package('audit').with(:ensure => 'latest') }
        end
      end

      describe 'auditd::config' do
        it { should contain_file('/etc/audit/auditd.conf').with_owner('0') }
        it { should contain_file('/etc/audit/auditd.conf').with_group('0') }
        it { should contain_file('/etc/audit/auditd.conf').with_mode('0640') }

        describe 'should allow path to be overridden' do
          let(:params) {{ :conf => '/etc/audit/foo.conf' }}
          it { should contain_file('/etc/audit/foo.conf').with_owner('0') }
          it { should contain_file('/etc/audit/foo.conf').with_group('0') }
          it { should contain_file('/etc/audit/foo.conf').with_mode('0640') }
        end
      end

      describe 'auditd::service' do
        let(:params) {{ :service_manage   => true,
                        :service_ensure   => 'running',
                        :service_enable   => true,
                        :service_name     => 'auditd',
                        :service_provider => 'systemd',
                        :use_augenrules   => true }}

        describe 'with serice_manage overridden' do
          let(:params) {{ :service_manage => false, }}
          it { should_not contain_service('enable auditd') }
          it { should_not contain_exec('systemctl reload auditd') }
          it { should_not contain_exec('/sbin/service auditd reload') }
        end

        describe 'with defaults' do
          it { should contain_service('enable auditd').with(
            :name   => 'auditd',
            :enable => true) }
          it { should contain_exec('systemctl reload auditd') }
          it { should contain_exec('augenrules --load') }
          it { should contain_exec('auditctl -R /etc/audit/auditd.rules') }
        end

        describe 'with service_provider overridden' do
          context 'when set to systemd' do
            let(:params) {{ :service_provider => 'systemd' }}
            it { should contain_exec('systemctl reload auditd') }
            it { should_not contain_exe('/sbin/service auditd reload') }
          end
          context 'when set to redhat' do
            let(:params) {{ :service_provider => 'redhat' }}
            it { should contain_exec('/sbin/service auditd reload') }
            it { should_not contain_exec('systemctl reload auditd') }
          end
          context 'when set to foo' do
            let(:params) {{ :service_provider => 'foo' }}
            it { should contain_exec('/sbin/service auditd reload') }
            it { should_not contain_exec('systemctl reload auditd') }
          end
        end

        describe 'with use_augenrules overridden' do
          let(:params) {{ :use_augenrules => false }}
          it { should_not contain_exec('augenrules --load') }
          it { should_not contain_exec('auditctl -R /etc/audit/auditd.rules') }
        end
      end

      describe 'auditd::rules' do
        let(:params) {{ :use_augenrules => true,
                        :rulesd_dir     => '/etc/audit/rules.d',
                        :purge_rules    => true }}

        describe 'with defaults' do
          it { should contain_file('/etc/audit/rules.d').with_purge(true) }
          it { should contain_file('/etc/audit/rules.d').with_recurse(true) }
          it { should contain_file('/etc/audit/rules.d/10-base.rules') }
          it { should contain_file('/etc/audit/rules.d/30-main.rules') }
          it { should contain_file('/etc/audit/rules.d/50-server.rules') }
          it { should contain_file('/etc/audit/rules.d/99-finalize.rules') }
        end

        describe 'with purge overridden' do
          let(:params) {{ :purge_rules => false }}
          it { should contain_file('/etc/audit/rules.d').with_purge(false) }
          it { should contain_file('/etc/audit/rules.d').with_recurse(false) }
        end

        ## this should be changed to a "real" test if an alternative to
        ##  augenrules is ever implemented
        describe 'with use_augenrules overridden' do
          let(:params) {{ :use_augenrules => false }}
          it {should_not contain_file('/etc/audit/rules.d')}
          it {should_not contain_file('/etc/audit/rules.d/10-base.rules')}
          it {should_not contain_file('/etc/audit/rules.d/30-main.rules')}
          it {should_not contain_file('/etc/audit/rules.d/50-server.rules')}
          it {should_not contain_file('/etc/audit/rules.d/99-finalize.rules')}
        end
      end
    end
  end
end
