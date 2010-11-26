class CallsController < ApplicationController
  
  def index
    @options={}
    APP_CONFIG.each_key do |controller|
      @options[controller]=APP_CONFIG[controller].keys
    end
  end

  def new
     @parameters=APP_CONFIG[params[:call][:controller]][params[:call][:action]]
     @call_controller = params[:call][:controller]
     @call_action = params[:call][:action]
     render :text=>"Invalid data" if @parameters.nil?
  end

  def create
    @parameters=APP_CONFIG[params[:call_controller]][params[:call_action]]
    @call_controller = params[:call_controller].to_s
    @call_action = params[:call_action].to_s

    params.delete('call_controller')
    params.delete('call_action')
    params.delete('method')
    params.delete('utf8')
    params.delete('authenticity_token')
    params.delete('commit')
    
    require 'getdata'
    gdata = GetData.new :controller => @call_controller, :action => @call_action, :params => params
    res = gdata.request.to_s
    logger.info res
    @result = res
    
    render :action => :new
  end


end
