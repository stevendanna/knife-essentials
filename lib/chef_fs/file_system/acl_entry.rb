#
# Author:: John Keiser (<jkeiser@opscode.com>)
# Copyright:: Copyright (c) 2013 Opscode, Inc.
# License:: Apache License, Version 2.0
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
#

require 'chef_fs/file_system/rest_list_entry'
require 'chef_fs/file_system/not_found_error'
require 'chef_fs/file_system/operation_not_allowed_error'
require 'chef_fs/file_system/operation_failed_error'

module ChefFS
  module FileSystem
    class AclEntry < RestListEntry
      def api_path
        "#{super}/_acl"
      end

      def delete(recurse)
        raise ChefFS::FileSystem::OperationNotAllowedError.new(:delete, self, e), "ACLs cannot be deleted."
      end

      def write(recurse)
        raise ChefFS::FileSystem::OperationNotAllowedError.new(:write, self, e), "ACLs are not (yet) supported."
      end
    end
  end
end
