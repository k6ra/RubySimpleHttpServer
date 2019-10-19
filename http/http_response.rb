class HttpResponse
    attr_accessor :version
    attr_accessor :status_code
    attr_accessor :status_message
    attr_accessor :content_type
    attr_accessor :body

    BODY_NOT_FOUND = <<~EOS
        <html>
            <title>404 NOT FOUND</title>
            <body>
                PAGE NOT FOUND
            </body>
        </html>
    EOS

    def initialize(version, path)
        @version = version

        if (File.exist?(path)) then
            file = File.open(path)
            @status_code = 200
            @body = file.read
            file.close        
        else
            puts "404"
            @status_code = 404
            @body = BODY_NOT_FOUND
        end
    end

    def write
        return <<~EOS
            HTTP/#{@version} #{@status_code} #{@status_message}
            Content-Type: text/html; charset=UTF-8

            #{@body}
        EOS
    end
end