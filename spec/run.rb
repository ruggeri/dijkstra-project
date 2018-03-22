require 'fiber'
require 'pp'
require 'rspec/support'

require_relative './graph.rb'
require_relative '../lib/04_dijkstra.rb'
require_relative './verified_message_logs'

vertices = build_graph()[:vertices]
start_vertex = vertices["ATL"]

$fiber = Fiber.new do
  dijkstra(start_vertex)
end

def build_message_logs
  messages = []
  while $fiber.alive?
    messages << $fiber.resume.to_hash
  end

  messages
end

def play_message_logs
  while $fiber.alive?
    msg = $fiber.resume.to_hash
    puts "=" * 40
    pp msg.to_hash
    gets
  end
end

def verify_message_logs
  require_relative './verified_message_logs'
  expected_logs = verified_message_logs

  prev_msg = nil
  while $fiber.alive?
    expected_message = expected_logs.shift
    msg = $fiber.resume.to_hash

    puts "=" * 40
    puts
    if msg != expected_message
      puts "EXPECTED"
      pp expected_message.to_a
      puts "RECEIVED"
      pp prev_msg.to_a
      puts "DIFF"
      differ = RSpec::Support::Differ.new(color: true)
      puts differ.diff(prev_msg.to_a, expected_message.to_a)
      break
    else
      pp msg
      puts
      prev_msg = msg
    end
  end
end

#play_message_logs
verify_message_logs
