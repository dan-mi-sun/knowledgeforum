class PostsController < ApplicationController

  def index
    @limit = 20
    if params[:offset] == nil 
      @offset = params[:offset].to_i
      @next_page = @offset + @limit 
    elsif
      @offset = 0
      @next_page =  @limit
    end 
      
    @posts = Post.offset(@offset_value).limit(20)
    #variable set by number user clicks
  end

  def search
    @results = Post.search(params[:search])
    #get params values 
  end

  def show
    @post = Post.find(params[:id])
  end
end
