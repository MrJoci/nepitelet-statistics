class BrandsController < ApplicationController
  def list
    render :text => ListMaker.list
  end
end
