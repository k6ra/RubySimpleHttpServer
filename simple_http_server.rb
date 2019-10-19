require 'socket'
require_relative 'http/http_request.rb'
require_relative 'http/http_response.rb'

server_ip = '127.0.0.1'
server_port = '80'
server = TCPServer.new(server_ip, server_port)
document_root = "c:\\DocumentRoot"

loop do
    socket = server.accept
    puts socket
    request = HttpRequest.new(socket.gets)
    response = HttpResponse.new("1.1", document_root + request.path)
    socket.print response.write
    socket.close
end