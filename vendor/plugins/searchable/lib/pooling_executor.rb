#!/usr/bin/env ruby

require 'thread'

# From: http://eigenclass.org/hiki.rb?simple+concurrency+ruby
class PoolingExecutor
  attr_reader :pool

  def initialize
    @mutex = Mutex.new
    @pool = []
    @handleravail = ConditionVariable.new
    @threads = {}
    yield self if block_given?
  end

  def add_handler(handler)
    @pool << handler 
  end

  alias_method :<<, :add_handler

  def run(logger = nil)
    handler = nil
    ref = []
    @mutex.synchronize do
      if @pool.size == 0
        @handleravail.wait @mutex until @pool.size > 0
      end
      handler = @pool.shift
      @threads[handler] = ref # so it can be removed from @threads in due time
      logger and logger.info("Got handler #{handler.inspect}.")
    end
    ref << Thread.new do
      begin
        logger and logger.info("Yielding handler #{handler.inspect} for execution.")
        yield handler
        logger and logger.info("Finished execution with #{handler.inspect}.")
      ensure
        @mutex.synchronize do
          @pool << handler
          @threads.delete handler
          @handleravail.signal
        end
      end
    end
    ref[0]
  end

  def wait_for_all
    @threads.each do |handler, thread|
      begin
        thread[0].join 
      rescue Exception
      end
    end
    @threads.clear
  end

  def num_tasks
    @threads.size
  end
end


if $0 == __FILE__
  executor = PoolingExecutor.new do |handlers|
    10.times do |i|
      handlers << lambda do |x|
        puts "<%2d>: #{x}" % i
        sleep(5 * rand)
      end
    end
  end
  require 'logger'
  logger = Logger.new(STDOUT)
  100.times{|i| executor.run(logger){|handler| handler[i] } }
  executor.wait_for_all
end