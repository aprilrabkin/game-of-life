require './game'
require 'sinatra'
class Server < Sinatra::Base

  get '/next_gen' do
    seeds = params["liveCells"].values.map{|a|[a.first.to_i, a.last.to_i]}
    g = Game.new(seeds)
    g.tick
    g.living_cells.entries.to_s
  end

end
