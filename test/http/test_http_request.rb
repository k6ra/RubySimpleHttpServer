require 'test/unit'
require_relative '../../src/http/http_request.rb'

class TestHttpRequest < Test::Unit::TestCase

    def test_create_request
        req = HttpRequest.new('GET /page/index.html HTTP/1.1')

        assert_equal('GET', req.method)
        assert_equal('\page\index.html', req.path)
        assert_equal('HTTP/1.1', req.version)
    end

end