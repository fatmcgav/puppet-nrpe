
class nrpe::config (
  $nrpe_cfg             = $nrpe::params::nrpe_cfg,
  $pid_file             = $nrpe::params::nrpe_pid_file,
  $port                 = $nrpe::params::port,
  $user                 = $nrpe::params::user,
  $group                = $nrpe::params::group,
  $nrpe_include_dir     = $nrpe::params::nrpe_include_dir,
  $nagios_plugins       = $nrpe::params::nagios_plugins,
  $nagios_extra_plugins = $nrpe::params::nagios_extra_plugins,
  $nagios_ips           = $nrpe::params::nagios_ips,
  $command_timeout      = $nrpe::params::command_timeout
  ) inherits nrpe::params {
   
  # NRPE config file 
  file { 'nrpecfg':
    path    => $nrpe_cfg,
    owner   => $user,
    group   => $group,
    mode    => 644,
    content => template('nrpe/nrpe.cfg.erb'),
    notify  => Class['nrpe::service'],
  }

  # NRPE include dir
  file { 'nrpeinclude':
    path   => $nrpe_include_dir,
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => 644,
  }

}
