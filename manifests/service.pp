class auditd::service inherits auditd {

  if $auditd::service_manage == true {

    service { 'enable auditd':
      name   => $auditd::service_name,
      enable => $auditd::service_enable,
    }

    case $auditd::service_provider {
      'systemd': {
        # SIGHUP triggers auditd to do a "reconfigure" where it reads the configuration from disk
        # the "grep -v '0'" is to have it do nothing in the case where systemd returns a default value for the pid
        # systemd will return 0 as the pid when for example the unit specified does not exist on the system
        exec { 'reload auditd':
          command     => "/usr/bin/kill -s SIGHUP $(systemctl show --property MainPID ${auditd::service_name} | cut -d '=' -f 2 | grep -v '0')",
          path        => ['/sbin', '/bin'],
          subscribe   => File[$auditd::conf],
          refreshonly => true,
        }
      }
      'redhat', default: {
        exec { 'reload auditd':
          command     => "/sbin/service ${auditd::service_name} reload",
          subscribe   => File[$auditd::conf],
          refreshonly => true,
        }
      }
    }
  }

  if $auditd::use_augenrules == true {

    exec { 'augenrules --load':
      path        => ['/sbin', '/bin', '/usr/bin'],
      refreshonly => true,
      subscribe   => [  File["${auditd::rulesd_dir}/10-base.rules"],
                        File["${auditd::rulesd_dir}/30-main.rules"],
                        File["${auditd::rulesd_dir}/50-server.rules"],
                        File["${auditd::rulesd_dir}/99-finalize.rules"] ],
    }

    exec { "auditctl -R ${auditd::rules_file}":
      path        => ['/sbin', '/bin'],
      refreshonly => true,
      subscribe   => Exec['augenrules --load'],
    }
  }
}
