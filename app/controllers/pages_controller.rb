class PagesController < ApplicationController
  def show
    @page = Page.find_by!(title: params[:title].capitalize)
  end
end
