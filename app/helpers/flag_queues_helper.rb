module FlagQueuesHelper
  def self.run_cycle
    FlagQueue.all.each do |queue|
      flags = queue.flags.where.not(:completed => true).load
      puts flags
      if flags.count > 0
        flag = flags.sort_by { |f| f.created_at }.first
        puts "Flagging #{flag.post_id} on #{flag.site.site_domain}"
        flag.send_flag
      end
    end
  end
end
