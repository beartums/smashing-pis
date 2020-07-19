require_relative './remote_action'
module RemoteActions
  class PiTemp < RemoteAction
    def initialize
      @action_string = Constants::RPI_TEMP_MILLICELSIUS_COMMAND
      @result_property_name = 'value'
      @widget_suffix = Constants::TEMP_WIDGET_SUFFIX
    end

    private 
      def massage(value)
        value.to_i/1000
      end
  end
end

