# attributes/default.rb

default['apt']['compile_time_update'] = true

default['zookeeper']['version']     = '3.4.8'
default['zookeeper']['checksum']    =
  'f10a0b51f45c4f64c1fe69ef713abf9eb9571bc7385a82da892e83bb6c965e90'
default['zookeeper']['mirror']      = 'http://apache.mirrors.tds.net/zookeeper/'
default['zookeeper']['user']        = 'zookeeper'
default['zookeeper']['user_home']   = '/home/zookeeper'
default['zookeeper']['install_dir'] = '/opt/zookeeper'
default['zookeeper']['use_java_cookbook'] = true
default['zookeeper']['config_dir']  = "#{node['zookeeper']['install_dir']}/" \
                                    'zookeeper-%{zookeeper_version}/conf'
default['zookeeper']['conf_file']   = 'zoo.cfg'
default['zookeeper']['java_opts']   = '-Xms128M -Xmx512M'
default['zookeeper']['log_dir']     = '/var/log/zookeeper'

# One of: 'upstart', 'runit', 'exhibitor', 'sysv'
default['zookeeper']['service_style'] = 'runit'

default['zookeeper']['config'] = {
  'clientPort' => 2181,
  'dataDir'    => '/var/lib/zookeeper',
  'tickTime'   => 2000,
  'initLimit'  => 5,
  'syncLimit'  => 2
}

default['zookeeper']['env_vars'] = {
  'ZOOCFGDIR'   => node['zookeeper']['config_dir'] % { zookeeper_version: node['zookeeper']['version'] },
  'ZOOCFG'      => node['zookeeper']['conf_file'],
  'ZOO_LOG_DIR' => node['zookeeper']['log_dir']
}

# Examples of additional environment vars
# See the zookeeper config files (conf/zkEnv.sh, etc.) for more options
# set['zookeeper']['env_vars']['ZOO_LOG4J_PROP'] = 'INFO,ROLLINGFILE'
# set['zookeeper']['env_vars']['ZOO_LOG_DIR'] = '/mnt/var/log/zookeeper'
