class HttpRequest
    attr_accessor :method
    attr_accessor :path
    attr_accessor :version

    def initialize(request)
        req_arr = request.split(" ")
        @method = req_arr[0]
        @path = req_arr[1].gsub(/\//, '\\\\')
        @version = req_arr[2]
    end
end