require 'chef/knife'

module TP
  class RoleReplace < Chef::Knife

  banner "knife role replace -s SEARCH_ROLE -o ROLE_TO_REPLACE -n NEW_ROLE"

  deps do
    require 'chef/node'
  end

  option :search_role,
    :short => '-s ROLE',
    :long => '--search_role ROLE'

  option :old_role,
    :short => '-o ROLE',
    :long => '--old_role ROLE'

  option :new_role,
    :short => '-n ROLE',
    :long => '--new_role ROLE'

    def search(attribute = "*", value = "*", include_node_data = false)
      response = include_node_data ? {} : []
      Chef::Search::Query.new.search(:node, attribute+":"+value) do |n|
        if include_node_data then
          response[n.name] = n unless n.nil?
        else
          response << n.name unless n.nil?
        end
      end
      response
    end

    def run
      s = search('role', "#{config[:search_role]}*")
      s.map do |host|
        @node = Chef::Node.load(host)

        list = @node.run_list
        ui.msg("Here is the current set of roles on this host: #{list}")

        @new_list = list.map do |ele|
          old_role_name = config[:old_role]

          if ele == "role[#{config[:old_role]}]"
            "role[#{config[:new_role]}]"
          else
            "#{ele}"
          end
        end

        ui.msg("Fixing up the run_list!\n")
        ui.msg("Here is the modified set of roles: #{@new_list}")

        @node.run_list(@new_list)
        @node.save
        ui.msg("Node run_list has been saved on #{host}.") unless !$?.success?
      end
    end

  end
end
