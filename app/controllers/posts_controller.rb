class PostsController < ApplicationController

  def index
    if params[:offset] == nil 
      @offset_value = 0  
    elsif
      start = params[:offset].to_i
      next_page = params[:offset].to_i
      @start_page_number = start + next_page  
    end 
      
    @posts = Post.offset(@offset_value).limit(20)
    #variable set by number user clicks
  end

  def show
    @post = Post.find(params[:id])
  end
end
