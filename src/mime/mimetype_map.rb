require 'singleton'
require 'json'

class MimetypeMap
    include Singleton

    def initialize
        File.open(File.dirname(__FILE__) + '/mimetype.json') do |file|
            @map = JSON.load(file)
        end
    end

    def [](extension)
        return @map[extension]
    end

private
    attr_accessor :map

end