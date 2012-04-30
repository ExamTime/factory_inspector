require 'factory_inspector/version'
require 'factory_inspector/report'
require 'active_support/notifications'

module FactoryInspector

  def self.new
    Inspector.new
  end

  class Inspector

    def start_inspection
      @reports = {}
      @inspection_start_time = Time.now
      ActiveSupport::Notifications.subscribe('factory_girl.run_factory') do |name, start_time, finish_time, id, payload|
        analyze(payload[:name], start_time, finish_time, payload[:strategy])
      end
    end

    def generate_report(output_filename)
      inspection_time_in_seconds = Time.now - @inspection_start_time
      factory_time_in_seconds = calculate_total_factory_time_in_seconds
      percentage_time_in_factories = ( (factory_time_in_seconds * 100) / inspection_time_in_seconds )

      file = File.open(output_filename, 'w')

      file.write "FACTORY INSPECTOR\n"
      file.write "  - #{@reports.values.size} factories used, #{calculate_total_factory_calls} calls made\n"
      file.write "  - #{sprintf("%6.4f",inspection_time_in_seconds)} seconds of testing inspected\n"
      file.write "  - #{sprintf("%6.4f",factory_time_in_seconds)} seconds in factories\n"
      file.write "  - #{sprintf("%4.1f",percentage_time_in_factories)}% testing time is factory calls\n"
      file.write "\n"
      file.write "  FACTORY NAME                     TOTAL  OVERALL   TIME PER  LONGEST   STRATEGIES\n"
      file.write "                                   CALLS  TIME (s)  CALL (s)  CALL (s)            \n"
      @reports.sort_by{ |name,report| report.time_per_call_in_seconds }.reverse.each do |report_name, report|
        line = sprintf("  %-30.30s % 5.0d    %8.4f    %5.5f  %5.4f      %s\n",
                     report.factory_name,
                     report.calls,
                     report.total_time_in_seconds,
                     report.time_per_call_in_seconds,
                     report.worst_time_in_seconds,
                     report.strategies)
        file.write(line)
      end

      file.close
    end

    # Callback for use by ActiveSupport::Notifications, not for end
    # user use directly though it has to be public for ActiveSupport
    # to see it.
    #
    # * [factory_name] Factory name
    # * [start_time] The start time of the factory call
    # * [finish_time] The finish time of the factory call
    # * [strategy] The strategy used when calling the factory
    #
    def analyze(factory_name, start_time, finish_time, strategy)
      if not @reports.has_key? factory_name
        @reports[factory_name] = FactoryInspector::Report.new(factory_name)
      end
      @reports[factory_name].update(finish_time - start_time, strategy)
    end

  private

    def calculate_total_factory_time_in_seconds
      @reports.values.reduce(0) do |total_time_in_seconds, report|
        total_time_in_seconds + report.total_time_in_seconds
      end
    end

    def calculate_total_factory_calls
      @reports.values.reduce(0) do |total_calls, report|
        total_calls + report.calls
      end
    end

  end

end
