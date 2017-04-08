class ChatController < ApplicationController
  include Tubesock::Hijack

  def index
    if session[:login] == nil
      redirect_to '/'
    end
    # @socket_url='ws://127.0.0.1:3000/chat_handler'
  end

  def chat_handler
    hijack do |client_sock|
      client_sock.on_message do |message|
        json_message = JSON.parse(message)

        if json_message['session_id'] != nil
          s_id = json_message['session_id']
          session_entry = JSON.parse(Session.find(session_id = s_id).first)
          session = Marshal.load(
              ActiveSupport::Base64(session_entry.value_csrf_token))
          login = session[:login]

          if login != nil
            $chat_users[login] = [client_sock, s_id]
            answer_json = {}
            answer_json['auth'] = 'yes'
            client_sock.send_data(answer_json)
            send_list_users
          else
            answer_json = {}
            answer_json['auth'] = 'no'
            client_sock.send_data(answer_json)
          end

          messages = ChatHelper::get_messages(login)
          messages.each do |mess|
            client_sock.send_data(mes)
          end
        end

        if json_message['broadcast'] != nil && get_user_by_socket(client_sock) != nil
          mess = json_message['broadcast']
          login = get_user_by_socket(client_sock)

          answer_json = {}
          answer_json['name'] = login
          answer_json['message'] = mess

          json_string = answer_json.to_json.to_s
          save_broadcast_message(login, mess)

          for value in $chat_users.values
            value[0].send_data(json_string)
          end
        end

        if json_message['name'] != nil && get_user_by_socket(client_sock) != nil
          receiver = json_message['name']
          sender = get_user_by_socket(client_sock)
          mess = json_message['message']
          receiver_sock = $chat_users[receiver]

          if receiver_sock != nil
            json_message = {}
            json_message['name'] = sender
            json_message['message'] = mess
            receiver_sock.send_data(json_message.to_json.to_s)
          else
            ChatHelper::save_message(sender, receiver, mess)
          end
        end

        if json_message['disconnect'] != nil && get_user_by_socket(client_sock) != nil
          login = get_user_by_socket(client_sock)
          s_id = $chat_users[login][1]

          $chat_users.delete(login)
          send_list_users

          Session.destroy_all(session_id == s_id)
          answer_json = {}
          answer_json['disconnect'] = 'yes'
          client_sock.send_data(answer_json)
        end

      end
    end

  end

  def get_user_by_socket(client_sock)
    for  key, value in $chat_users
      if value[0] == client_sock
        return key
      end
    end

    return nil
  end

  def send_list_users
    list_users = []

    $chat_users.keys.each do |key|
      list_users.push(key)
    end

    answer_json = {}
    answer_json['list'] = list_users
    json = answer_json.to_json.to_s

    for value in $chat_users.values
      value[0].send_data(json)
    end
  end

end
