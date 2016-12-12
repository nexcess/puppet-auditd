class auditd::audisp (
  Boolean $manage,
  String $audispd_conf,
  String $plugindir,
  Numeric $q_depth,
  String $overflow_action,
  Integer[0] $audispd_priority_boost,
  Integer[0] $max_restarts,
  String $audispd_name_format,
  Optional[String] $audispd_name,
  Boolean $install_plugins,
  String $plugin_package_name,
  Optional[Hash] $plugins,
) {

  if $manage {
    contain auditd::audisp::install
    contain auditd::audisp::config
    contain auditd::audisp::plugins

    Class['::auditd::audisp::install'] ->
    Class['::auditd::audisp::config'] ->
    Class['::auditd::audisp::plugins']
  }
}
