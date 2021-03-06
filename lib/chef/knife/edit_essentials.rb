require 'chef_fs/knife'
require 'chef_fs/file_system'
require 'chef_fs/file_system/not_found_error'

class Chef
  class Knife
    remove_const(:Edit) if const_defined?(:Edit) && Edit.name == 'Chef::Knife::Edit' # override Chef's version
    class Edit < ::ChefFS::Knife
      ChefFS = ::ChefFS
      banner "knife edit [PATTERN1 ... PATTERNn]"

      common_options

      option :local,
        :long => '--local',
        :boolean => true,
        :description => "Show local files instead of remote"

      def run
        # Get the matches (recursively)
        error = false
        pattern_args.each do |pattern|
          ChefFS::FileSystem.list(config[:local] ? local_fs : chef_fs, pattern) do |result|
            if result.dir?
              ui.error "#{format_path(result)}: is a directory" if pattern.exact_path
              error = true
            else
              begin
                new_value = edit_text(result.read, File.extname(result.name))
                if new_value
                  result.write(new_value)
                  output "Updated #{format_path(result)}"
                else
                  output "#{format_path(result)} unchanged!"
                end
              rescue ChefFS::FileSystem::OperationNotAllowedError => e
                ui.error "#{format_path(e.entry)}: #{e.reason}."
                error = true
              rescue ChefFS::FileSystem::NotFoundError => e
                ui.error "#{format_path(e.entry)}: No such file or directory"
                error = true
              end
            end
          end
        end
        if error
          exit 1
        end
      end

      def edit_text(text, extension)
        if (!config[:disable_editing])
          file = Tempfile.new([ 'knife-edit-', extension ])
          begin
            # Write the text to a temporary file
            file.open
            file.write(text)
            file.close

            # Let the user edit the temporary file
            if !system("#{config[:editor]} #{file.path}")
              raise "Please set EDITOR environment variable"
            end

            file.open
            result_text = file.read
            return result_text if result_text != text

          ensure
            file.close!
          end
        end
      end
    end
  end
end

