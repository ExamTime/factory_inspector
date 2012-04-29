require 'factory_inspector/version'
require 'factory_inspector/report'
require 'active_support/notifications'

module FactoryInspector

  def self.new
    Inspector.new
  end

  class Inspector

    def initialize
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
                     report.name,
                     report.calls,
                     report.total_time,
                     report.time_per_call_in_seconds,
                     report.worst_time,
                     report.strategies)
        file.write(line)
      end

      file.close
    end

  private

    def analyze(name, start_time, finish_time, strategy)
      if not @reports.has_key? name
        @reports[name] = FactoryInspector::Report.new(name)
      end
      @reports[name].update(finish_time - start_time, strategy)
    end

  end

end
