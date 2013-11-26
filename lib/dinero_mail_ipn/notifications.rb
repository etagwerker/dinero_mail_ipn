require 'nokogiri'

module DineroMailIpn
  class NotificationParser
    attr_reader :doc

    # @param [String] XML file containing DM IPNv2 operations.
    # @param [Hash] a Hash of optional parameters.
    def initialize(xml_file, options = {})
      raise ArgumentError, "No XML provided" if xml_file.nil?

      @xsd = Nokogiri::XML::Schema(xsd_file('notifications.xsd'))
      @doc = Nokogiri::XML(xml_file.downcase)
    end

    # Parses the XML notification POSTed by DineroMail IPNv2
    # notification system.
    #
    # @return [DineroMailIpn::Notification] a parsed Notification
    def parse
      return unless valid?

      type = @doc.xpath("//tiponotificacion").text

      operations = @doc.xpath("//operacion").inject([]) do |result, operation|
        result << [operation.xpath('tipo').text, operation.xpath('id').text]
        result
      end

      notification = Notification.new(type, operations)

      notification
    end

    # Checks that the XML document is valid.
    #
    # @return [Boolean]
    def valid?
      @xsd.valid?(@doc)
    end

    # Retrieves an [Array] of [Nokogiri::XML::Schema::SyntaxError]
    # with the XML document errors.
    #
    # @return [Array] list of errors found on the XML document
    def validate
      @xsd.validate(@doc)
    end

    private

    # Locates an XSD file.
    #
    # @param filename [String] the XSD filename
    def xsd_file(filename)
      xsd_file_location = File.expand_path("../../../resources/validation/xsd/#{filename}", __FILE__)
      xsd_file = File.read(xsd_file_location)
      xsd_file
    end
  end

  class Notification
    attr_accessor :type, :operations

    def initialize(type, raw_operations, options = {})
      raise ArgumentError, "No operations received" if (raw_operations.empty? || raw_operations.nil?)

      @operations = raw_operations.inject([]) do |result, (type, id)|
        result << Operation.new(type, id)
        result
      end

      @type = type
    end
  end

  class Operation < Struct.new(:type, :id); end
end
