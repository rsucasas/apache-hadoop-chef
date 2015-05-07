action :create do
  Chef::Log.info "Creating hdfs directory: #{@new_resource.name}"

  bash "mk-dir-#{new_resource.name}" do
    user "#{new_resource.owner}"
    group "#{new_resource.group}"
    code <<-EOF
     set -e
     . #{node[:hadoop][:home]}/sbin/set-env.sh
     #{node[:hadoop][:home]}/bin/hdfs dfs -mkdir -p #{new_resource.name}
     #{node[:hadoop][:home]}/bin/hdfs dfs -chgrp #{new_resource.group} #{new_resource.name}
     if [ "#{new_resource.mode}" != "" ] ; then
        #{node[:hadoop][:home]}/bin/hadoop fs -chmod #{new_resource.mode} #{new_resource.name} 
     fi
    EOF
#  not_if ". #{node[:hadoop][:home]}/sbin/set-env.sh && #{node[:hadoop][:home]}/bin/hdfs dfs -test -d #{new_resource.name}"
  end
 
end


action :put do
  Chef::Log.info "Putting file(s) into hdfs directory: #{@new_resource.name}"

  bash "hdfs-put-dir-#{new_resource.name}" do
    user "#{new_resource.owner}"
    group "#{new_resource.group}"    
    code <<-EOF
     set -e
     . #{node[:hadoop][:home]}/sbin/set-env.sh
     #{node[:hadoop][:home]}/bin/hdfs dfs -put #{new_resource.name} #{new_resource.dest}
     #{node[:hadoop][:home]}/bin/hdfs dfs -chgrp #{new_resource.group} #{new_resource.name}
     if [ "#{new_resource.mode}" != "" ] ; then
        #{node[:hadoop][:home]}/bin/hadoop fs -chmod #{new_resource.mode} #{new_resource.dest} 
     fi
    EOF
#    not_if "#{node[:hadoop][:home]}/bin/hadoop dfs -test -e #{new_resource.dest}"
  end
 
end
