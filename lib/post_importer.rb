class PostImporter < Nokogiri::XML::SAX::Document
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
    logger.debug c.strip.chomp if c
  end

  def start_element(name, attrs)
     if name == 'row' 
       self.post_count += 1
         Hash[attrs].each do |k, v|
           case k
           when "Id", "AcceptedAnswerId", "Score", "ViewCount", "AnswerCount"
             self.last_post[k.underscore.to_sym]= v.to_i
           when "Body"
             self.last_post[k.downcase.to_sym] = v
           when "Title"
             self.last_post[k.downcase.to_sym] = v.gsub(/'&quot;'/, '')
           when "Tags"
             self.last_post[k.downcase.to_sym] = v.gsub(/</, '').split('>')
           when "CreationDate"
             self.last_post[k.underscore.to_sym] = v
           end
         end
     end
     logger.debug "Found element #{name}"

  end

  def end_element(name)
    logger.debug "Finished element #{name}"
  end

  protected
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
