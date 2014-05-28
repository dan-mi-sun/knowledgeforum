module PostsHelper

  def page_counter
    start = 0 
    next_page = params[:change_page].to_i
    page = start + next_page
    start =+ next_page
  end

end
