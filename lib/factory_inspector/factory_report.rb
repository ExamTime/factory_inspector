module FactoryInspector
  #
  # Report on how a FactoryGirl Factory was used in a test run.
  # Holds simple metrics and can be updated with new calls.
  class FactoryReport

    attr_reader :name, :calls, :worst_time, :total_time, :strategies

    # Initialise a new report
    # * [name] The name of the factory being reported on
    def initialize(name)
      @name = name
      @calls = 0
      @worst_time = 0
      @total_time = 0
      @strategies = []
    end

    def time_per_call_in_seconds
      @total_time / @calls
    end

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
      @worst_time = time if time > @worst_time
      @total_time += time
    end

  end

end
