class auditd::rules inherits auditd {

  if $auditd::use_augenrules == true {

    file { $auditd::rulesd_dir:
      ensure  => directory,
      purge   => $auditd::purge_rules,
      recurse => $auditd::purge_rules,
      owner   => 0,
      group   => 0,
      mode    => '0640',
    }

    file { "${auditd::rulesd_dir}/10-base.rules":
      ensure  => present,
      owner   => 0,
      group   => 0,
      mode    => '0640',
      content => epp('auditd/rules/10-base.rules.epp'),
    }

    file { "${auditd::rulesd_dir}/30-main.rules":
      ensure  => present,
      owner   => 0,
      group   => 0,
      mode    => '0640',
      content => epp('auditd/rules/30-main.rules.epp'),
    }

    file { "${auditd::rulesd_dir}/50-server.rules":
      ensure  => present,
      owner   => 0,
      group   => 0,
      mode    => '0640',
      content => epp('auditd/rules/50-server.rules.epp'),
    }

    file { "${auditd::rulesd_dir}/99-finalize.rules":
      ensure  => present,
      owner   => 0,
      group   => 0,
      mode    => '0640',
      content => epp('auditd/rules/99-finalize.rules.epp'),
    }
  }
}
