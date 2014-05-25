require_relative 'post_handler'

class PostImporter < Nokogiri::XML::SAX::Document
  include PostHandler

  # A logger to output to the screen
  attr_accessor :logger

  # A counter to increment each time you find a page
  attr_accessor :post_count

  # The output SQL file
  attr_accessor :sql

  # The contents of the last page as a hash
  attr_accessor :last_post

  def initialize(logger)
    self.logger = logger
    self.post_count = 0
    self.last_post = {}
    @output_file_count = 0
  end

  def start_document
    logger.debug "Start document"
  end

  def end_document
    logger.debug "End document"
  end

  def characters(c)
    logger.debug c
  end

  def start_element(name, attrs)
    logger.debug "Found element #{name}"
  end

  def end_element(name)
    logger.debug "Finished element #{name}"

    # Call a handler name based on the name of the element
    self.send(handler_method(name))
  end

  def method_missing(m, *args, &block)
    logger.debug("Ignoring #{m}")
  end

  protected

  # Build the name of a method dynamically based on an elements name
  #
  def handler_method(name)
    :"handle_#{name.downcase}"
  end

  # Remove any unwanted whitespace and escape single quotes for use in PSQL
  #
  def clean(s)
    s.strip.gsub("'", "''")
  end

  # Build an output SQL filename based on the current file count. Increment
  # @output_file_count every 50k results to spread the statements into smaller
  # chunks.
  #
  def output_file_name
    "/tmp/posts-#{@output_file_count}.sql"
  end
end