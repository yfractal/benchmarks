iterations_count = 1_000_000

def ping_pong_in_threads(iterations_count)
  r0, w0 = IO.pipe
  r1, w1 = IO.pipe

  w1.write('a')
  started_at = Time.now

  [Thread.new{
    iterations_count.times {
      r1.read(1)
      w0.write('a')
    }
  }, Thread.new{
    iterations_count.times {
      r0.read(1)
      w1.write('a')
    }
  }].each{|t| t.join}
  ended_at = Time.now

  ended_at - started_at
end

def ping_pong_in_thread(iterations_count)
  iterations_count = 100_000
  r, w = IO.pipe
  started_at = Time.now
  [Thread.new{
    iterations_count.times{
      w.write('a')
      r.read(1)
    }
  }].each{|t| t.join}
  ended_at = Time.now

  ended_at - started_at
end

threads_cost = ping_pong_in_threads(iterations_count)
thread_cost = ping_pong_in_thread(iterations_count)
cost = threads_cost / ( 2 * iterations_count) - thread_cost / iterations_count

puts %{
iterations_count=#{iterations_count}, threads_cost=#{threads_cost}s, thread_cost=#{thread_cost}s
Thread context swith cost: #{cost}s, #{cost * 1_000_000}µs
}
