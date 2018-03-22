require 'fiber'
require 'pp'
require 'rspec/support'

require_relative './graph.rb'
require_relative '../lib/04_dijkstra.rb'
require_relative './verified_message_logs'

def build_message_logs
  vertices = build_graph()[:vertices]
  start_vertex = vertices["ATL"]

  fiber = Fiber.new do
    dijkstra(start_vertex)
  end

  messages = []
  while fiber.alive?
    messages << fiber.resume.to_hash
  end

  messages
end

# Used to generate verified logs
def print_message_logs
  messages = build_message_logs

  messages.each do |msg_hash|
    puts "=" * 40
    pp msg_hash
  end
end

def verify_message_logs
  expected_logs = verified_message_logs

  vertices = build_graph()[:vertices]
  start_vertex = vertices["ATL"]

  fiber = Fiber.new do
    dijkstra(start_vertex)
  end

  prev_msg = nil
  while fiber.alive?
    expected_message = expected_logs.shift
    msg = fiber.resume.to_hash

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

verify_message_logs
