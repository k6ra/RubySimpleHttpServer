class HttpRequest
    attr_reader :method
    attr_reader :path
    attr_reader :version

    def initialize(method, path, version)
        @method = method
        @path = path
        @version = version
    end

private
    attr_writer :method
    attr_writer :path
    attr_writer :version
end