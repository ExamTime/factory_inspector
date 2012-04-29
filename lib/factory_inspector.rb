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
      ActiveSupport::Notifications.subscribe('factory_girl.run_factory') do |name, start_time, finish_time, id, payload|
        analyze(payload[:name], start_time, finish_time, payload[:strategy])
      end
    end

    def generate_report(output_filename)
      file = File.open(output_filename, 'w')

      file.write "FACTORY INSPECTOR - #{@reports.values.size} FACTORIES USED\n"
      file.write "  FACTORY NAME                TOTAL  OVERALL   TIME PER  LONGEST   STRATEGIES\n"
      file.write "                              CALLS  TIME (s)  CALL (s)  CALL (s)            \n"
      @reports.sort_by{ |name,report| report.time_per_call_in_seconds }.reverse.each do |report_name, report|
        line = sprintf("  %-25.25s % 5.0d    %5.4f    %5.5f  %5.4f      %s\n",
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

  end

end
