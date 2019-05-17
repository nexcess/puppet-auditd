class auditd (
  String $conf,
  String $log_file,
  String $log_format,
  String $log_group,
  Integer $priority_boost,
  String $flush,
  Integer[0] $freq,
  Integer[0, 99] $num_logs,
  String $disp_qos,
  String $dispatcher,
  String $name_format,
  Optional[String] $admin_name,
  Numeric $max_log_file,
  String $max_log_file_action,
  Numeric $space_left,
  String $space_left_action,
  String $action_mail_acct,
  Numeric $admin_space_left,
  String $admin_space_left_action,
  String $disk_full_action,
  String $disk_error_action,
  Optional[Integer[1, 65535]] $tcp_listen_port,
  Integer $tcp_listen_queue,
  Integer[1, 1024] $tcp_max_per_addr,
  Boolean $use_libwrap,
  Optional[Variant[Integer[1, 65535], Pattern[/\n-\n/]]] $tcp_client_ports,
  Integer $tcp_client_max_idle,
  Boolean $enable_krb5,
  String $krb5_principal,
  Optional[String] $krb5_key_file,
  Boolean $service_manage,
  String $service_ensure,
  Boolean $service_enable,
  String $service_name,
  Optional[String] $service_provider,
  Boolean $manage_package,
  String $package_name,
  String $package_state,
  Boolean $use_augenrules,
  Integer $rules_buffer_size,
  Integer[0,2] $rules_failure_mode,
  String $rulesd_dir,
  String $rules_file,
  Boolean $purge_rules,
  Optional[Array] $base_rules,
  Optional[Array] $main_rules,
  Optional[Array] $server_rules,
  Optional[Array] $finalize_rules,
) {

  contain auditd::install
  contain auditd::rules
  contain auditd::config
  contain auditd::service
  contain auditd::audisp

  Class['::auditd::install'] ->
  Class['::auditd::config'] ->
  Class['::auditd::rules'] ->
  Class['::auditd::audisp'] ->
  Class['::auditd::service']
}
