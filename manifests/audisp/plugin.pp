define auditd::audisp::plugin (
  Boolean $active = true,
  Pattern[/^in$/, /^out$/] $direction = 'out',
  String $path = undef,
  Pattern[/^builtin$/, /^always$/] $type = 'always',
  Array[String, 0, 2] $args = [],
  Pattern[/^binary$/, /^string$/] $format = 'string',
) {
  include ::auditd::service

  $pparams = {  'active'     => $active,
                'direction'  => $direction,
                'path'       => $path,
                'type'       => $type,
                'args'       => $args,
                'format'     => $format }

  file { "${::auditd::audisp::plugindir}/${name}.conf":
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0640',
    content => epp('auditd/audisp/plugin.epp', $pparams),
    notify  => Exec['reload auditd'],
  }
}
