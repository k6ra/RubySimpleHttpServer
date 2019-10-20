require 'base64'

class HttpResponse
    attr_accessor :version
    attr_accessor :status_code
    attr_accessor :status_message
    attr_accessor :content_type
    attr_accessor :body

    def initialize(version, path)
        @version = version

        if (File.exist?(path)) then
            create_response(path)
        else
            create_not_found_response
        end
    end

    def write
        return <<~EOS
            HTTP/#{@version} #{@status_code} #{@status_message}
            Content-Type: #{@content_type}

            #{@body}
        EOS
    end

private
    def create_response(path)
        file = File.open(path, 'rb')
        @status_code = 200
        @status_message = 'OK'
        @content_type = get_content_type(File.extname(path).gsub('.', ''))
        @body = file.read
        file.close       
    end

    def get_content_type(extension)
        case extension
        when 'html'
            return 'text/html; charset=UTF-8'
        when 'gif'
            return 'image/gif'
        end
    end

    def create_not_found_response
        @status_code = 404
        @status_message = ''
        @content_type = 'text/html; charset=UTF-8'
        @body = <<~EOS
            <html>
                <title>404 NOT FOUND</title>
                <body>
                    PAGE NOT FOUND
                </body>
            </html>
        EOS
    end
end