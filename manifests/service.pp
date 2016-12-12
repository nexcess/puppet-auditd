class auditd::service inherits auditd {

  if $auditd::service_manage == true {

    service { 'enable auditd':
      name   => $auditd::service_name,
      enable => $auditd::service_enable,
    }

    ## puppet doesn't really give an easy way to do reloads instead of restarts
    case $auditd::service_provider {
      'systemd': {
        exec { 'reload auditd':
          command     => "systemctl reload ${auditd::service_name}",
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
      path        => ['/sbin', '/bin'],
      refreshonly => true,
      subscribe   => [  File["${auditd::rulesd_dir}/10-base.rules"],
                        File["${auditd::rulesd_dir}/30-main.rules"],
                        File["${auditd::rulesd_dir}/50-server.rules"],
                        File["${auditd::rulesd_dir}/99-finalize.rules"] ],
    }

    exec { 'auditctl -R /etc/audit/auditd.rules':
      path        => ['/sbin', '/bin'],
      refreshonly => true,
      subscribe   => Exec['augenrules --load'],
    }
  }
}
