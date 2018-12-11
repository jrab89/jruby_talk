require 'prime'
require 'concurrent'

max = ARGV[0].to_i
thread_count = ARGV[1].to_i

pool = Concurrent::FixedThreadPool.new(thread_count)
2.upto(max) do
  pool.post do
    Prime.prime_division(max)
  end
end

pool.shutdown
pool.wait_for_termination