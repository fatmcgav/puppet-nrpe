
define nrpe::plugin ( 
  $ensure               = 'present', 
  $plugin               = "main", 
  $check_command, 
  $sudo                 = false,
  $user                 = $nrpe::params::user,
  $group                = $nrpe::params::group,
  $nrpe_include_dir     = $nrpe::params::nrpe_include_dir,
  $nagios_plugins       = $nrpe::params::nagios_plugins,
  $nagios_extra_plugins = $nrpe::params::nagios_extra_plugins
)  {

  file { "nrpe_plugin_${name}":
    ensure  => $ensure,
    path    => "${nrpe_include_dir}/${name}.cfg",
    owner   => $user,
    group   => $group,
    mode    => 644,
    content => template("nrpe/nrpe_service.cfg.erb"),
    notify  => Class['nrpe::service'],
  }
  
}
