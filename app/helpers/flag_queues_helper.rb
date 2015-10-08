module FlagQueuesHelper
  def self.run_cycle
    cycle_start = DateTime.now

    FlagQueue.all.each do |queue|
      next if queue.last_run + queue.frequency.seconds > DateTime.now

      flags = queue.flags.where.not(:completed => true).load
      puts flags

      if flags.count > 0
        queue.last_run = cycle_start
        queue.save!

        flag = flags.sort_by { |f| f.created_at }.first
        puts "Flagging #{flag.post_id} on #{flag.site.site_domain}"
        flag.send_flag
      end
    end
  end
end
