class auditd::install inherits auditd {

  if $auditd::manage_package == true {
    package { $auditd::package_name:
      ensure => $auditd::package_state,
    }
  }
}
