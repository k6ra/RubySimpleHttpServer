class HttpResponse
    attr_accessor :version
    attr_accessor :status_code
    attr_accessor :status_message
    attr_accessor :content_type
    attr_accessor :body

    def write
        return <<~EOS
            HTTP/#{@version} #{@status_code} #{@status_message}
            Content-Type:#{@content_type}

            #{@body}
        EOS
    end

end