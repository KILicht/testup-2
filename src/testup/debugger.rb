#-------------------------------------------------------------------------------
#
# Copyright 2013-2018 Trimble Inc.
# License: The MIT License (MIT)
#
#-------------------------------------------------------------------------------


module TestUp
  module Debugger

    # Outputs a string to the system debugger. Can be seen with DebugView.
    # Useful when tracing BugSplats.
    # TestUp::Debugger.output
    def self.output(value)
      return nil unless TestUp.settings[:debugger_output_enabled]
      require 'Win32API'
      @OutputDebugString ||=
        Win32API.new('kernel32', 'OutputDebugString', 'P', 'V')
      @OutputDebugString.call("#{value}\n\0")
    end

    # TestUp::Debugger.debugger_output?
    def self.debugger_output?
      TestUp.settings[:debugger_output_enabled]
    end

    # TestUp::Debugger.debugger_output = true
    def self.debugger_output=(value)
      TestUp.settings[:debugger_output_enabled] = value ? true : false
    end

    # Time the given block and output it to the system debugger.
    def self.time(title, &block)
      start = Time.now
      block.call
    ensure
      lapsed_time = Time.now - start
      self.output("TestUp::Debugger.time: #{title} #{lapsed_time}s")
      nil
    end

  end # module Debugger
end # module
