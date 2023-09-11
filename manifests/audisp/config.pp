class auditd::audisp::config inherits auditd::audisp {

  include ::auditd::service

  file { $auditd::audisp::audispd_conf:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0640',
    content => epp('auditd/audisp/audispd_conf.epp'),
  }
}
