require 'chef_fs/data_handler/data_handler_base'

module ChefFS
  module DataHandler
    class AclDataHandler < DataHandlerBase
      def normalize(node, entry)
        # Normalize the order of the keys for easier reading
        result = super(node, {
          'create' => {},
          'read' => {},
          'update' => {},
          'delete' => {},
          'grant' => {}
          })
        result.keys.each do |key|
          result[key] = super(result[key], { 'actors' => [], 'groups' => [] })
          result[key]['actors'] = result[key]['actors'].sort
          result[key]['groups'] = result[key]['groups'].sort
        end
        result
      end
    end
  end
end
