module ChatHelper
  def get_messages(receiver)
    output = []

    mess = Message.joins(:chat_users).where('chat_users.login = ?', receiver)
    mess.each do |m|
      login = m.sender.login
      body = m.body

      json = {}
      json['name'] = login
      json['message'] = body

      output.push(json)
    end

    broadcast_messages = $redis.lrange('broadcast', 0, -1)
    broadcast_messages.each do |bm|
      bm_array = bm.split(':')
      login = bm_array[0]
      br_m = bm_array[1]

      json = {}
      json['name'] = login
      json['message'] = br_m

      output.push(json)
    end

    output
  end

  def save_message(sender, receiver, message)
    sn = ChatUser.find_by_login(sender)
    rs = ChatUser.find_by_login(receiver)

    m = Message.new(body: message, sender_id: sn, receiver_id: rs)
    m.save
  end

  def save_broadcast_message(sender, message)
    $redis.lpush('broadcast', sender + ':' + message)

  end
end
