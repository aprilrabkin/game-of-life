require './game'
require 'sinatra'

get '/' do
  if params && params["liveCells"] && params["liveCells"].values && params["liveCells"].values.map{|a|[a.first.to_i, a.last.to_i]}
    seeds = params["liveCells"].values.map{|a|[a.first.to_i, a.last.to_i]}
    g = Game.new(seeds)
    g.tick
    g.living_cells.entries.to_s
  else
    "Try (with jquery):
        $.ajax({
          url: 'http://aprils-game-of-life.herokuapp.com',
          jsonp: 'callback',
          dataType: 'jsonp',
          data:   {
              'M': 5,
              'N': 5,
              'liveCells' : [[2,1],[2,2],[2,3]]
            },
          success: function(response) {
            console.log(response);
          }
        });
    "
  end
end