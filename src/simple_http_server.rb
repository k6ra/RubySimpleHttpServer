require 'socket'
require_relative './http/request_handler.rb'

server_ip = '127.0.0.1'
server_port = '80'
server = TCPServer.new(server_ip, server_port)

loop do
    socket = server.accept

    Thread.fork socket do |s|
        s.write RequestHandler.new(s.gets).handle_request if s != nil
        s.close
    end

end