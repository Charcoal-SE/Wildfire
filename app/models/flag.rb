class Flag < ActiveRecord::Base
  belongs_to :site
  belongs_to :flag_queue
  belongs_to :flag_type



  def link
    if self.comment_ids.present?
      comment_ids = self.comment_ids.split(",")
      return ActionController::Base.helpers.link_to("#{comment_ids.first}", "http://" + self.site.site_domain + "/posts/comments/" + comment_ids.first) + ((comment_ids.count > 1) ? " <span class='text-muted'>and #{comment_ids.count - 1} more</span>" : " <span class='text-muted'> (comment)").html_safe
    else
      return ActionController::Base.helpers.link_to(self.post_id.to_s, "http://" + self.site.site_domain + "/q/" + self.post_id.to_s)
    end
  end

  def send_flag(dry_run=false)
    # 1. Figure out if post is an answer or question
    # 2. Check if post has changed since it was registered for flagging (last activity date)
    # 3. Ask for flag options
    # 4. See if the user's chosen flag option is available
    # 5. Flag

    if self.comment_ids.present?
      send_comment_flags(dry_run)
      return
    end
    
    site = self.site
    user = self.flag_queue.user

    post = Net::HTTP.get(URI.parse("http://api.stackexchange.com/2.2/posts/#{self.post_id}?site=#{site.site_domain}&filter=!-.5dR.mQlmgI&key=#{APP_CONFIG['stack_api']['key']}"))
    parsed_json = JSON.parse(post)

    if parsed_json["items"] and parsed_json["items"].count > 0
      post = parsed_json["items"][0]
      self.post_type = post["post_type"]
      self.save!

      last_activity_date = post["last_activity_date"]

      if Time.at(last_activity_date) < self.created_at.to_time
        options_url = "https://api.stackexchange.com/2.2/#{self.post_type}s/#{self.post_id}/flags/options"
        params = "?key=#{APP_CONFIG["stack_api"]["key"]}&access_token=#{user.access_token}&site=#{site.site_domain}"
        options_response = Net::HTTP.get(URI.parse(options_url + params))

        options = JSON.parse(options_response)

        options = options["items"].group_by{|a| a["title"]}

        if options.include? self.flag_type.name
          option_id = options[self.flag_type.name][0]["option_id"]
          puts "Flagging with option #{option_id}"

          params = {'option_id' => option_id, 'id' => self.post_id, 'site' => site.site_domain, 'key' => APP_CONFIG["stack_api"]["key"], "access_token" => user.access_token, "preview" => dry_run.to_s}

          url = "https://api.stackexchange.com/2.2/#{self.post_type}s/#{self.post_id}/flags/add"
          puts url

          response = JSON.parse(Net::HTTP.post_form(URI.parse(url), params).body)

          if response["error_message"] != nil and response["error_message"].length > 0
            self.failure_reason = response["error_message"]
          else
            self.completed = true
          end
        else
          self.failure_reason = "Flag type '#{self.flag_type.name}' not available on post"
        end        
      else
        self.failure_reason = "Post modified since flag enqueued"
      end
    else
      self.failure_reason = "Couldn't find post (API returned empty)"
    end

    self.attempted_at = DateTime.now
    self.save!
  end

  def send_comment_flags(dry_run=false)
    comments = self.comment_ids.split(",")
    comments.each do |comment|
      sleep 6
      error = send_flag_for_comment(comment, dry_run)

      if error.present?
        self.failure_reason = error
        break        
      end
    end

    self.completed = true
    self.attempted_at = DateTime.now
    self.save!
  end

  def send_flag_for_comment(comment_id, dry_run=false)
    site = self.site
    user = self.flag_queue.user

    options_url = "https://api.stackexchange.com/2.2/comments/#{comment_id}/flags/options"
    params = "?key=#{APP_CONFIG["stack_api"]["key"]}&access_token=#{user.access_token}&site=#{site.site_domain}"
    options_response = Net::HTTP.get(URI.parse(options_url + params))

    options = JSON.parse(options_response)

    options = options["items"].group_by{|a| a["description"]}

    if options.include? self.flag_type.name
      option_id = options[self.flag_type.name][0]["option_id"]
      puts "Flagging with option #{option_id}"

      params = {'option_id' => option_id, 'id' => self.post_id, 'site' => site.site_domain, 'key' => APP_CONFIG["stack_api"]["key"], "access_token" => user.access_token, "preview" => dry_run.to_s}

      url = "https://api.stackexchange.com/2.2/comments/#{comment_id}/flags/add"
      puts url

      response = JSON.parse(Net::HTTP.post_form(URI.parse(url), params).body)

      if response["backoff"] != nil and response["backoff"].length > 0
        puts "Backoff recieved; waiting #{response["backoff"]} seconds"
        sleep response["backoff"].to_i
      end

      if response["error_message"] != nil and response["error_message"].length > 0
        return response["error_message"]
      else
        return nil #no error
      end
    else
      return "Flag type '#{self.flag_type.name}' not available on comment"
    end
  end
end
