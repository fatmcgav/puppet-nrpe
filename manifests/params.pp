class nrpe::params (
  $user            = 'nrpe',
  $group           = 'nrpe',
  $port            = 5666,
  $nagios_ips, # comma separated list of ips that can talk to nrpe
  $command_timeout = 180,
  $command_args    = true, # Allow command line args
  $firewall        = false, ## disabling this for now
)
{
  # ACT config settings
  $nrpe_cfg = '/usr/local/nagios/etc/nrpe.cfg'
  $nrpe_include_dir = '/usr/local/nagios/etc/nrpe.d'
  $nagios_plugins = '/usr/local/nagios/libexec'
  $nagios_extra_plugins = hiera('monitoring::nagios_extra_plugins', undef)
  $nrpe_package = 'act-nrpe'
  $nrpe_plugins = 'act-nagios-plugins'
  $nrpe_pid_file = '/var/run/nrpe.pid'
  
  case $lsbdistdescription {
    ## some tricky logic to use systemd on fedora 17+
    /Fedora release (.+)/: {
      if versioncmp($1,"17") >= 0 {
        $nrpe_service = 'nrpe.service'
        $nrpe_provider = 'systemd'
      }
    }
    /^(Debian|Ubuntu)/: {
      $nrpe_service = 'nagios-nrpe-server'
      $nrpe_provider = undef
    }
    default: {
      $nrpe_service = 'nrpe'
      $nrpe_provider = undef
    }
  }
  
  /*
  case $operatingsystem {
    default: {
      $nrpe_package = 'nrpe'
      $nrpe_check_package = 'nagios-plugins-nrpe'
      $pid_file = '/var/run/nrpe/nrpe.pid'
      #$nrpe_service = 'nrpe'
    }
    /(Debian|Ubuntu)/: {
      $nrpe_package = 'nagios-nrpe-server'
      $nrpe_check_package = 'nagios-nrpe-plugin'
      #$nrpe_service = 'nagios-nrpe-server'
      $pid_file = '/var/run/nagios/nrpe.pid'
    }
  }
  
  */
  
}
