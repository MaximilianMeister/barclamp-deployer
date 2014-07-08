#
# Copyright 2011-2013, Dell
# Copyright 2013-2014, SUSE LINUX Products GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :remove do
  service_name = [*new_resource.service_name]

  # HA part if node is in a cluster and a cluster founder
  if CrowbarPacemakerHelper.cluster_name node and \
       CrowbarPacemakerHelper.is_cluster_founder? node

    service_name.each do |name|
      name.slice! "openstack-"

      pacemaker_primitive name do
        action [:stop, :delete]
        only_if "crm configure show #{name}"
      end
    end
  end

  # Non HA part if service is on a standalone node
  service_name.each do |name|
    service name do
      action [:stop, :disable]
    end
  end
end
