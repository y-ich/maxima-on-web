#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# Maxima server on Sinatra
# author: ICHIKAWA, Yuji
# date: 2011/07/15
# Copyright (C) 2011 ICHIKAWA, Yuji

require 'rubygems'
require 'sinatra'
require './maxima'

CGI_FILE = '/Users/yuji/Projects/maxima-on-web/public/cgi-bin/maxima.rb'
`mv #{CGI_FILE} #{CGI_FILE + '.tmp'}` if File.exist?(CGI_FILE)
ENV['PATH'] = '/Applications/Gnuplot.app/Contents/Resources/bin:' + ENV['PATH'] # gnuplot用パスを追加


# set :public, '/Users/yuji/Sites'
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
      `mv #{CGI_FILE + '.tmp'} #{CGI_FILE}` if File.exist?(CGI_FILE + '.tmp')
    end
  end
end

