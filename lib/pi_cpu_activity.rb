require_relative './remote_action'
module RemoteActions
  class PiCpuActivity < RemoteAction
    def initialize
      @action_string = Constants::RPI_IDLE_CPU_PERCENT_COMMAND
      @result_property_name = 'value'
      @widget_suffix = Constants::CPU_WIDGET_SUFFIX
    end

    private 
      def massage(value)
        (100 - value.to_f).round(0)
      end
  end
end

