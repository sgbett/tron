class TronModulesController < ApplicationController
  
  def create
    render text: params.inspect

  end
  
end
