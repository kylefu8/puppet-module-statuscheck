# == Class: module-statuscheck
class statuscheck (
  $max_age = 'USE_DEFAULTS',
  $pid_path = 'USE_DEFAULTS',
  $command_path = '/usr/local/bin/statuscheck.sh',
  $status = 'present',
  $owner  = 'root',
  $group  = 'root',
  $mode   = '755',
  $cron_mins = [07,22,38,52],
#  $cron_hour = '0',
){
  
  if $max_age == 'USE_DEFAULTS' {
     $max_age_real = '120'
  } else {
     $max_age_real = $max_age
  }

  if $pid_path == 'USE_DEFAULTS' {
     $pid_path_real = '/var/lib/puppet/state/agent_catalog_run.lock'
  } else {
     $pid_path_real = $pid_path
  }

  file { 'statuscheck.sh' :
    ensure => file,
    path   => $command_path,
    content => template('statuscheck/statuscheck.erb'),
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
 
  cron { 'statuscheck' :
    ensure  => $status,
    command => "${command_path} > /dev/null 2>&1",
    user    => $owner,
#    hour    => $cron_hour,
    minute  => $cron_mins,
  }
}
