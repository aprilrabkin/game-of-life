require 'set'
require 'sinatra'
require 'pry'
class Game 

  attr_accessor :living_cells, :candidates

  def initialize(living_cells=[])
    @living_cells = Set.new(living_cells)
  end

  def count_neighbors(cx, cy, this_cell_alive)
    count = 0
    (cx-1..cx+1).each do |nx|
      (cy-1..cy+1).each do |ny|
        if !(cx == nx && (cy == ny)) # exclude the current cell
          if living_cells.member?([nx,ny])
            count += 1
          elsif this_cell_alive 
            # if this cell is alive and the neighbor is dead 
            # we will later consider whether to revive the neighbor, a candidate cell
            candidates << [nx,ny]
          end
        end
      end
    end
    count
  end

  def tick
    next_gen = Set.new
    @candidates = Set.new
    living_cells.each do |c|
      count = count_neighbors(c.first, c.last, true)
      if (count == 2 || (count == 3))
        next_gen << c
      end
    end
    candidates.each do |c|
      count = count_neighbors(c.first, c.last, false)
      if count == 3
        next_gen << c
      end
    end
    @living_cells = next_gen
  end

  def get_grid_dimensions
    c = living_cells.first #arbitrary choice of cell, bc neighborhood may be far from 0,0
    xmin, xmax = c.first, c.first
    ymin, ymax = c.last, c.last
    living_cells.each do |c|
      x = c.first
      y = c.last
      if x > xmax
        xmax = x
      end
      if x < xmin 
        xmin = x 
      end
      if y > ymax
        ymax = y 
      end
      if y < ymin
        ymin = y 
      end
    end
    {xmin: xmin, xmax: xmax, ymin: ymin, ymax: ymax}
  end

  def print_grid
    dimensions = get_grid_dimensions
    (dimensions[:ymin]..dimensions[:ymax]).each do |y|
      (dimensions[:xmin]..dimensions[:xmax]).each do |x|
        if living_cells.member?([x,y])
          print "O"
        else
          print " "
        end
      end
      print "\n"
    end
  end

  def pass_time(seconds)
    time = 0
    while time < seconds do
      print_grid
      tick
      sleep 1
    end
  end

end

class Server < Sinatra::Base
  
  get '/next_gen' do
    seeds = params["liveCells"].values.map{|a|[a.first.to_i, a.last.to_i]}
    g = Game.new(seeds)
    g.tick
    g.living_cells.entries.to_s
  end

end

Server.run!