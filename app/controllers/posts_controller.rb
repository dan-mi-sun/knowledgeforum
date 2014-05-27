class PostsController < ApplicationController

  def index
    @posts = Post.limit(20)
  end
end
