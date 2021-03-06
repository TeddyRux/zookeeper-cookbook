# recipes/service.rb
#
# Copyright 2013, Simple Finance Technology Corp.
# Copyright 2016, EverTrue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

executable_path = ::File.join(node['zookeeper']['install_dir'],
                              "zookeeper-#{node['zookeeper']['version']}",
                              'bin',
                              'zkServer.sh')

case node['zookeeper']['service_style']
when 'upstart'
  template '/etc/init/zookeeper.conf' do
    source 'zookeeper.upstart.erb'
    mode '0644'
    variables(
      exec: executable_path,
      user: node['zookeeper']['user']
    )
    notifies :restart, 'service[zookeeper]', :delayed
  end

  service 'zookeeper' do
    provider Chef::Provider::Service::Upstart
    supports status: true, restart: true
    action [:enable, :start]
  end
when 'runit'
  # runit_service does not install runit itself
  include_recipe 'runit'

  runit_service 'zookeeper' do
    default_logger true
    owner node['zookeeper']['user']
    group node['zookeeper']['user']
    options(
      exec: executable_path
    )
    action [:enable, :start]
  end
when 'sysv'
  template '/etc/init.d/zookeeper' do
    source 'zookeeper.sysv.erb'
    mode '0755'
    variables(
      exec: executable_path,
      user: node['zookeeper']['user']
    )
    notifies :restart, 'service[zookeeper]'
  end

  service_provider = value_for_platform_family(
    'rhel'    => Chef::Provider::Service::Init::Redhat,
    'default' => Chef::Provider::Service::Init::Debian
  )

  service 'zookeeper' do
    provider service_provider
    supports status: true, restart: true
    action [:enable, :start]
  end
when 'exhibitor'
  Chef::Log.info('Assuming Exhibitor will start up Zookeeper.')
else
  Chef::Log.error('You specified an invalid service style for Zookeeper, but I am continuing.')
end
