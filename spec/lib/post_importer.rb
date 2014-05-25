require 'spec_helper'

describe PostImporter do

  before do
    @sample_post = File.read('spec/fixtures/Post.xml')
    @document = PostImporter.new(Rails.logger)
  end

  describe "a new PostImporter object" do
    it "should set the post count to 0" do
      expect(@document.post_count).to eq(0)
    end

    it "should create an empty hash to store post attributes" do
      expect(@document.last_post).to eq({})
    end
  end

  context "using a stubbing approach" do
    it "should enter callbacks for each part of the XML document" do
      @document.expects(:start_document).once
      @document.expects(:start_element_namespace).times(2)
      @document.expects(:characters).twice
      @document.expects(:handle_row).once
      @document.expects(:end_document).once

      @parser = Nokogiri::XML::SAX::Parser.new(@document)
      @parser.parse(@sample_post)
    end
  end

  # TODO - Make these pass first, then try with larger datasets.
  context "with real data" do
    before do
      @parser = Nokogiri::XML::SAX::Parser.new(@document)
      @parser.parse(@sample_post)
    end

    it "counts how many results it found" do
      expect(@document.post_count).to eq(1)
    end

    it "keeps a hash of the last page" do
      expect(@document.last_post.is_a?(Hash)).to be true
      expect(@document.last_post[:id]).to eq(1)
      expect(@document.last_post[:accepted_answer_id]).to eq(13)
      expect(@document.last_post[:score]).to eq(101)
      expect(@document.last_post[:view_count]).to eq(12414)
      expect(@document.last_post[:body]).to_not be_nil
      expect(@document.last_post[:title]).to match(/Comments are a code smell/)
      expect(@document.last_post[:answer_count]).to eq(35)
      expect(@document.last_post[:comment_count]).to eq(12)
      expect(@document.last_post[:favourite_count]).to eq(34)
      expect(@document.last_post[:tags]).to eq(%w(commets anti-patterns))
      expect(@document.last_post[:created_at]).to eq('2010-09-01T19:34:48.000')
    end

    it "creates an SQL file ready to import the article" do
      sql_file = '/tmp/posts-0.sql'
      expect(File.exist?(sql_file)).to be_true

      sql = File.read(sql_file)
      expect(sql).to eq("INSERT INTO posts (created_at, updated_at, title, body) VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'It''s a great article', '#{@article.body}');\n")

      # Try it!
      Post.connection.execute(sql)
      Post.count.should eq(1)
    end
  end

end
