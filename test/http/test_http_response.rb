require 'test/unit'
require 'fileutils'
require_relative '../../src/http/http_response.rb'


class TestHttpResponse < Test::Unit::TestCase
    TEST_FILE_PATH_EXIST = 'test_http_response_exist.html'
    TEST_FILE_PATH_NOT_EXIST = 'test_http_response_not_exist'

    RESPONSE_EXIST_FILE = <<~EOS
        HTTP/1.1 200 OK
        Content-Type: text/html; charset=UTF-8

        test
    EOS

    RESPONSE_NOT_EXIST_BODY = <<~EOS
        <html>
            <title>404 NOT FOUND</title>
            <body>
                PAGE NOT FOUND
            </body>
        </html>
    EOS

    RESPONSE_NOT_EXIST_FILE = <<~EOS
        HTTP/1.1 404 
        Content-Type: text/html; charset=UTF-8

        #{RESPONSE_NOT_EXIST_BODY}
    EOS

    def setup
        open(TEST_FILE_PATH_EXIST, 'w') { |f|
            f.print 'test'
        }
    end

    def teardown
        FileUtils.rm(TEST_FILE_PATH_EXIST)
    end

    def test_create_response_exist_file
        res = HttpResponse.new('1.1', TEST_FILE_PATH_EXIST)

        assert_equal(200, res.status_code)
        assert_equal('OK', res.status_message)
        assert_equal('text/html; charset=UTF-8', res.content_type)
        assert_equal('test', res.body)
        assert_equal(RESPONSE_EXIST_FILE, res.write)
    end

    def test_create_response_not_exist_file
        res = HttpResponse.new('1.1', TEST_FILE_PATH_NOT_EXIST)

        assert_equal(404, res.status_code)
        assert_equal('', res.status_message)
        assert_equal('text/html; charset=UTF-8', res.content_type)
        assert_equal(RESPONSE_NOT_EXIST_BODY, res.body)
        assert_equal(RESPONSE_NOT_EXIST_FILE, res.write)
    end
end