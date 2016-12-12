class auditd::audisp::plugins (
  Optional[Hash] $plugins = $auditd::audisp::plugins,
){
  unless empty($plugins) {
    create_resources('auditd::audisp::plugin', $plugins)
  }
}
