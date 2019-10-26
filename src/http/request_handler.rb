require_relative '../mime/mimetype_map.rb'
require_relative 'http_request.rb'
require_relative 'http_response.rb'

class RequestHandler

    def initialize(stream)
        @stream = stream
    end

    def handle_request
        request = parse_request
        response = assign_response(request)
        return response.write
    end

private
    attr_accessor :stream

    BAD_REQUEST_PATH = '/BadRequest.html'
    METHOD_NOT_ALLOWED_PATH = '/MethodNotAllowed.html'
    NOT_FOUND_PATH = '/NotFound.html'

    def parse_request
        return nil if @stream.nil? || @stream.empty?
        method, path, version = @stream.match(/(.*?)\s(.*?)\s(.*?)\s(.*)/).captures
        return HttpRequest.new(method, path, version)       
    end

    def assign_response(request)
        return create_response(400, 'Bad Request', BAD_REQUEST_PATH) if request.nil?

        case request.method
        when 'GET'
            if (File.exist?(File.dirname(__FILE__) + '/../html' + request.path)) then
                return create_response(200, 'OK', request.path)
            else
                return create_response(404, 'Not Found', NOT_FOUND_PATH)
            end
        else
            return create_response(405, 'Method Not Allowed', METHOD_NOT_ALLOWED_PATH)
        end
    end

    def create_response(status_code, status_message, request_path)
        response = HttpResponse.new
        response.version = '1.1'
        response.status_code = status_code
        response.status_message = status_message

        if request_path == '/' then
            response.content_type = MimetypeMap.instance[".html"]
            path = File.dirname(__FILE__) + '/../html/index.html'
        else
            response.content_type = MimetypeMap.instance[File.extname(request_path)]
            path = File.dirname(__FILE__) + '/../html/' + request_path
        end

        File.open(path, 'rb') do |file|
            response.body = file.read
        end

        return response       
    end
end