module FactoryInspector

  # Report on how a FactoryGirl Factory was used in a test run.
  # Holds simple metrics and can be updated with new calls.
  class Report

    attr_reader :factory_name,
                :calls,
                :worst_time_in_seconds,
                :total_time_in_seconds,
                :strategies

    def initialize(factory_name)
      @factory_name = factory_name
      @calls = 0
      @worst_time_in_seconds = 0
      @total_time_in_seconds = 0
      @strategies = []
    end

    def time_per_call_in_seconds
      return 0 if @calls == 0
      @total_time_in_seconds / @calls
    end

    # Update this report with a new call
    # * [time] The time taken, in seconds, to call the factory
    # * [strategy] The strategy used by the factory
    def update(time, strategy)
      record_call
      record_time time
      if not @strategies.include? strategy
        @strategies << strategy
      end
    end

  private

    def record_call
      @calls += 1
    end

    def record_time(time)
      @worst_time_in_seconds = time if time > @worst_time_in_seconds
      @total_time_in_seconds += time
    end

  end

end
