# Define: nrpe::plugin
#
# This defined type can be used to register a new monitoring plugin
# in Nagios, and copy the file/template into the relevant location.
# Either file or template must be specificed.  
#
# Parameters:
# 
# [*check_command*]        - The command to run
# [*ensure*]               - Required resource state
# [*file*]                 - File location. Defaults to undef. 
# [*template*]             - Template location. Defaults to undef. 
# [*plugin-type*]          - Plugin type - file or template.
# [*sudo*]                 - Sudo permissions required to execute command?
# [*user*]                 - Plugin owning user. 
# [*group*]                - Plugin owning group.
# [*nrpe_include_dir*]     - Directory to create config include files in. Defaults to $nrpe::params::nrpe_include_dir.
# [*nagios_plugins*]       - Nagios plugins directory. Defaults to $nrpe::params::nagios_plugins.
# [*nagios_extra_plugins*] - Nagios extra plugins directory. Defaults to $nrpe::params::nagios_extra_plugins.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#
define nrpe::plugin (
  $check_command, 
  $ensure               = 'present',  
  $file                 = undef,
  $template             = undef,
  $plugin_type          = 'file',
  $sudo                 = false,
  $user                 = $nrpe::params::user,
  $group                = $nrpe::params::group,
  $nrpe_include_dir     = $nrpe::params::nrpe_include_dir,
  $nagios_plugins       = $nrpe::params::nagios_plugins,
  $nagios_extra_plugins = $nrpe::params::nagios_extra_plugins
)  {

  # Check we've got all the info we need...
  if ( $plugin_type == 'template' and $template == undef ) {
    fail("Nrpe::Plugin: template needs template")
  }
  if ( $plugin_type == 'file' and $file == undef ) {
    fail("Nrpe::Plugin: file needs file")
  }

  # Copy plugin to host
  file { $name:
    ensure  => $ensure,
    path    => "${nagios_plugins}/${name}",
    mode    => '0755',
    owner   => $user,
    group   => $group,
    source  => $plugin_type ? { 'file' => $file, default => undef },
    content => $plugin_type ? { 'template' => template($template), default => undef }
  }

  # Register plugin in Nagios
  file { "nrpe_plugin_${name}":
    ensure  => $ensure,
    path    => "${nrpe_include_dir}/${name}.cfg",
    owner   => $user,
    group   => $group,
    mode    => 644,
    content => template("nrpe/nrpe_service.cfg.erb"),
    require => File[$name],
    notify  => Class['nrpe::service']
  }
  
}
