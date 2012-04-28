require "factory_inspector/version"
require "factory_inspector/report"

module FactoryInspector

  def self.new(output_filename)
    Inspector.new(output_filename)
  end

  class Inspector

    attr_reader :output_filename

    def initialize(output_filename)
      @output_filename = output_filename
      @reports = {}
    end

    def generate_report
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

    def analyze(name, start_time, finish_time, strategy)
      if not @reports.has_key? name
        @reports[name] = FactoryInspector::Report.new(name)
      end
      @reports[name].update(finish_time - start_time, strategy)
    end

  end

end
