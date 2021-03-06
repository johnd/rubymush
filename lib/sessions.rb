class Session

  attr_accessor :socket, :player

  def self.clients
    @@clients || []
  end

  def self.add_client(session)
    @@clients ||= []
    @@clients << session
  end

  def self.delete_client(session)
    @@clients ||= []
    @@clients.delete session
  end

  def self.broadcast(message)
    Kernel.puts "BROADCAST MESSAGE: #{message}"
    self.clients.each do |client|
      client.puts "[BROADCAST] " + message
    end
  end

  def initialize(socket)
    @socket = socket
    @player = nil
    Session.add_client(self)
    Kernel.puts "Client connection from #{socket.remote_address.ip_address}"
    log_in_user
  end

  def puts(text)
    @socket.puts text
  end

  def print(text)
    @socket.print text
  end

  def gets
    @socket.gets
  end

  def log_in_user
    self.print "Username: "
    username = self.gets.chop
    self.print "Password: "
    password = self.gets.chop
    if verify_password(username, password)
      @player = Player.find_for_login(username)
      self.puts "Welcome, #{@player.name}."
      Kernel.puts "Player ##{@player.id}:#{@player.name} connected."
    else
      self.puts "I do not recognise you."
      close_connection
    end
  end

  def close_connection
    Kernel.puts "Closing connection with #{socket.remote_address.ip_address}."
    self.puts "Goodbye."
    socket.close
    Session.delete_client(self)
    Session.broadcast "#{player.name} has left."
  end

  private

  def verify_password(username, password)
    if user = Player.find_for_login(username)
      if user.password == password
        return true
      end
    end
    false
  end

end
