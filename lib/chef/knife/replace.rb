require 'chef/knife'

module TP

  def self.search(attribute = "*", value = "*", include_node_data = false)
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

  class RoleReplace < Chef::Knife

    banner "knife role replace -s search_role -o role_to_replace -n new_role "

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

    def run
      search_role = config[:search_role]
      #search_role = @name_args

      s = TP::search('role', "#{search_role}*")
      s.map do |host|
        node = Chef::Node.load(host)

        list = node.run_list
        ui.msg("Here is the current run_list: #{list}")

        begin

          new_list = list.map do |ele|
            if rest.get_rest("/roles/#{config[:new_role]}")
              if ele == "role[#{config[:old_role]}]"
                "role[#{config[:new_role]}]"
              else
                "#{ele}"
              end
            end
          end

          ui.msg("Fixing up the run_list!\n")
          ui.msg("Here is the modified run_list: #{new_list}")

          node.run_list(new_list)
          node.save

          if $?.success?
            ui.msg("Node run_list has been saved on #{host}.")
          else
            ui.fatal("Node run_list has been NOT saved on #{host}!")
          end

        rescue Net::HTTPServerException 
          ui.fatal("Role: '#{config[:new_role]}' was not found on the server. Did you upload it?")
        end 
      end
    end

  end

  class RoleAdd < Chef::Knife

    banner "knife role add -s search_role -n new_role -p position "

    deps do
      require 'chef/node'
    end

    option :search_role,
      :short => '-s ROLE',
      :long => '--search_role ROLE'

    option :position,
      :short => '-p position',
      :long => '--position position'

    option :new_role,
      :short => '-n new_role',
      :long => '--new_role role'

    def run
      #search_role = @name_args
      search_role = config[:search_role]

      s = TP::search('role', "#{search_role}*")
      s.map do |host|
        node = Chef::Node.load(host)

        list = node.run_list
        ui.msg("Here is your current run_list: #{list}")

        begin
          if rest.get_rest("/roles/#{config[:new_role]}")
            new_list = list.to_a.insert("#{config[:position]}".to_i, "role[#{config[:new_role]}]")
          end

          ui.msg("Here is your new run_list: #{new_list}")
          node.run_list(new_list)
          node.save

        rescue Net::HTTPServerException
          ui.fatal("Role: '#{config[:new_role]}' was not found on the server. Did you upload it?")
        end
      end
    end

  end
end
