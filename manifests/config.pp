class auditd::config inherits auditd {

  file { $auditd::conf:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0640',
    content => epp('auditd/auditd_conf.epp'),
  }
}
