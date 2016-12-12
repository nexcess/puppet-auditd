class auditd::audisp::install inherits auditd::audisp {

  if $auditd::audisp::install_plugins {
    package { $auditd::audisp::plugin_package_name:
      ensure => present,
    }
  }
}
