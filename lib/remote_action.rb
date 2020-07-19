module RemoteActions

  class RemoteExecutionError < StandardError; end

  # a remote action is a job that we push to other servers and expect a return value from.
  # it limits our data access and requires we have passwords and static IP addresses, but prevents us from
  # having to install processes on every server

  class RemoteAction
    attr_accessor :action_string, :widget_suffix, :result_property_name

    # definitely needs to be overridden
    def initialize(action: nil, result_property: nil, suffix: nil)
      @action_string = action.nil? ? '' : action
      @widget_suffix = suffix.nil? ? '' : suffix
      @result_property_name = result_property.nil? ? 'value' : result_property
    end

    def call(server, ssh)
      begin
        raw_value = exec(ssh)
      rescue RemoteExecutionError => e
        value = 'ERR'
        error = e.message
        puts e
      else
        value = massage(raw_value)
        error = nil
      ensure
        send(server, value, error)
      end
    end
    
    def exec(ssh)
      result = nil
      ssh.exec! action_string do |ch, stream, data|
        if stream == :stderr
          raise RemoteExecutionError.new(data)
        else
          result = data
        end
      end
      result
    end

    def send(server, value, error, additional_values = nil)
      hash_to_send = results_hash(server, value, error, additional_values)
      send_event(widget_id(server), hash_to_send)
    end

    private
      # probably needs to be overridden
      def massage(value)
        value.to_f
      end

      def widget_id(server)
        suffix = widget_suffix.nil? ? '' : widget_suffix
        server["name"] + suffix
      end

      def results_hash(server, value, error, additional_info = nil)
        hash = {
          moreinfo: server["ip"],
          "#{result_property_name}": value 
        }
        hash.merge(error: error) unless error.nil?
        hash
      end

  end
end
