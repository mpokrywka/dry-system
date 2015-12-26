require 'memoizable'
require 'inflecto'

module Dry
  module Component
    def self.Loader(input)
      Loader.new(Loader.identifier(input), Loader.path(input))
    end

    class Loader
      include Memoizable

      IDENTIFIER_SEPARATOR = '.'.freeze
      PATH_SEPARATOR = '/'.freeze

      attr_reader :identifier, :path, :file

      def self.identifier(input)
        input.to_s.gsub(PATH_SEPARATOR, IDENTIFIER_SEPARATOR)
      end

      def self.path(input)
        input.to_s.gsub(IDENTIFIER_SEPARATOR, PATH_SEPARATOR)
      end

      def initialize(identifier, path)
        @identifier = identifier
        @path = path
        @file = "#{path}.rb"
      end

      def name
        Inflecto.camelize(path)
      end
      memoize :name

      def constant
        Inflecto.constantize(name)
      end
      memoize :constant

      def instance(*args)
        constant.new(*args)
      end
    end
  end
end