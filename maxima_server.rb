#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# Maxima server on Sinatra
# author: ICHIKAWA, Yuji
# date: 2011/07/15
# Copyright (C) 2011 ICHIKAWA, Yuji

require 'rubygems'
require 'sinatra'
require './maxima'

enable :sessions

post '/cgi-bin/maxima.rb' do
  if session[:sessionid].nil? 
    m = Maxima.new
    session[:sessionid] = m.id
  else
    m = Maxima.get_instance(session[:sessionid])
    if m.nil?
      m = Maxima.new
      session[:sessionid] = m.id
    end
  end 
  m.response(params[:cmd])
end

# 後始末
module Sinatra
  class Application
    def Application.quit!(server, handler_name)
      super(server, handler_name)
      Maxima.cleanup
    end
  end
end

