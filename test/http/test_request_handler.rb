require 'test/unit'
require_relative '../../src/http/request_handler.rb'

class TestRequestHandler < Test::Unit::TestCase

    def test_normal_request
        response = RequestHandler.new("GET /Sample.html HTTP/1.1\r\n").handle_request
    
        file = File.open(File.dirname(__FILE__) + '/../../src/html/sample.html', 'rb')
        body = file.read
        file.close

        result = <<~EOS
            HTTP/1.1 200 OK
            Content-Type:text/html;charset=utf8

            #{body}
        EOS
        assert_equal(result, response)
    end

    def test_index_request
        response = RequestHandler.new("GET / HTTP/1.1\r\n").handle_request
    
        file = File.open(File.dirname(__FILE__) + '/../../src/html/index.html', 'rb')
        body = file.read
        file.close

        result = <<~EOS
            HTTP/1.1 200 OK
            Content-Type:text/html;charset=utf8

            #{body}
        EOS
        assert_equal(result, response)
    end

    def test_post_request
        response = RequestHandler.new("POST / HTTP/1.1\r\n").handle_request
    
        file = File.open(File.dirname(__FILE__) + '/../../src/html/MethodNotAllowed.html')
        body = file.read
        file.close

        result = <<~EOS
            HTTP/1.1 405 Method Not Allowed
            Content-Type:text/html;charset=utf8

            #{body}
        EOS
        assert_equal(result, response)
    end

    def test_bad_request
        response = RequestHandler.new(nil).handle_request
    
        file = File.open(File.dirname(__FILE__) + '/../../src/html/BadRequest.html')
        body = file.read
        file.close

        result = <<~EOS
            HTTP/1.1 400 Bad Request
            Content-Type:text/html;charset=utf8

            #{body}
        EOS
        assert_equal(result, response)
    end
end