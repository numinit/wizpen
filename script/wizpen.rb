#!/usr/bin/env ruby

# Wizpen, a Pigpen-inspired metafont for wizard spellbooks in D&D
#
# This is a generator for a pigpen-style LaTeX metafont suitable for wizard
# spellbooks in D&D-style games.
#
# Licensed under the LaTeX Project Public License.
#
# This source is awful. Sorry.

GRID_A = {
  A: 1..2,
  B: 1..3,
  C: 2..3,
  D: 0..2,
  E: 0..3,
  F: 2..0,
  G: 0..1,
  H: 3..1,
  I: 3..0,

  J: 1...2,
  K: 1...3,
  L: 2...3,
  M: 0...2,
  N: 0...3,
  O: 2...0,
  P: 0...1,
  Q: 3...1,
  R: 3...0,
}

GRID_B = {
  S: 1..3,
  T: 0..2,
  U: 2..0,
  V: 3..1,

  W: 1...3,
  X: 0...2,
  Y: 2...0,
  Z: 3...1
}

GRID_C = {
  :'0' => 3...1,
  :'1' => 1..2,
  :'2' => 1..3,
  :'3' => 2..3,
  :'4' => 0..2,
  :'5' => 0..3,
  :'6' => 2..0,
  :'7' => 0..1,
  :'8' => 3..1,
  :'9' => 3..0,
}

CORNERS = {
  0 => %i[west north],
  1 => %i[east north],
  2 => %i[east south],
  3 => %i[west south]
}

TRIANGLES_A = {
  0 => [%i[west vm], %i[west north], %i[hm north], %i[west vm]],
  1 => [%i[hm north], %i[east vm], %i[east north], %i[hm north]],
  2 => [%i[east vm], %i[hm south], %i[east south], %i[east vm]],
  3 => [%i[hm south], %i[west vm], %i[west south], %i[hm south]]
}

TRIANGLES_B_MAP = {
  0 => [%i[west north], %i[west south], %i[east south], %i[west north]],
  1 => [%i[west north], %i[east north], %i[east south], %i[west north]]
}

TRIANGLES_B = {
  1..3 => 0,
  0..2 => 1,
  2..0 => 0,
  3..1 => 1
}

TEX_CORNERS = {
  north: :top,
  south: :bot,
  west: :lft,
  east: :rt
}

def range_to_corners range, grid
  vertices = []
  triangles = []
  diagonals = []
  negative = []

  idx = range.begin % 4
  start = idx
  finish = (range.end + 1) % 4

  close = false
  if finish == idx
    # We need to close the shape
    finish = (finish - 1) % 4
    close = true
  end

  while idx != finish
    vertex = CORNERS[idx]
    vertices << vertex

    negative << vertex if idx == start && !close

    idx = (idx + 1) % 4

    negative << CORNERS[idx] if idx == finish && !close

    if close || idx != finish
      triangle = TRIANGLES_A[idx]
      triangles << triangle
      triangle.each do |point|
        if (point.include?(:vm) or point.include?(:hm)) and !negative.include?(point)
          negative << point
        end
      end
    end
  end

  vertices << CORNERS[idx]

  if close
    idx = (idx + 1) % 4
    vertices << CORNERS[idx]
    triangle = TRIANGLES_A[idx]
    triangles << triangle
    triangle.each do |point|
      if point.include?(:vm) or point.include?(:hm) and point == negative.first
        negative << point
      end
    end
  end

  diagonals << TRIANGLES_B_MAP[TRIANGLES_B[range.begin..range.end]]

  CORNERS.each do |key, point|
    if !negative.include? point and !triangles.any? {|t| t.include? point}
      negative << point
    end
  end

  if negative.first != negative.last
    negative << negative.first
  end

  {
    vertices: vertices,
    negative: negative,
    triangles: triangles,
    diagonals: diagonals
  }
end

def get_letter_spec letter
  letter = letter.upcase.to_sym
  range = GRID_A[letter]
  grid = :A
  if range.nil?
    range = GRID_B[letter]
    grid = :B
  end

  if range.nil?
    range = GRID_C[letter]
    grid = :C
  end

  return nil if range.nil?

  {
    letter: letter,
    range: range,
    grid: grid,
    fill: range.exclude_end?,
    corners: range_to_corners(range, grid),
  }
end

def draw_corners corners
  variables = {}
  order = []
  bbox = {}
  cycle = false

  corners.each_with_index do |corner, idx|
    if idx > 0 && corner == corners[0]
      # Loop back
      cycle = true
    else
      latex = corner.map {|c| TEX_CORNERS[c]}
      var = 'z%d' % variables.length
      variables[var] = corner
      order << var
      if latex.compact.length == latex.length
        bbox[latex] = var
      end
    end
  end

  {variables: variables, order: order, bbox: bbox, cycle: cycle}
end

version = ARGV[0] || '0.0.0'

puts <<PREAMBLE
% Wizpen, a Pigpen-inspired metafont for wizard spellbooks in D&D
% Based on the Pigpen metafont: https://ctan.org/pkg/pigpen
%
% https://github.com/numinit/wizpen
%
% Version #{version}
%
% (C) 2008 Oliver Corff
% (C) 2018 Morgan Jones
%
% Licensed under the LaTeX Project Public License.
%
% Special greets to Battlemage Brewery, host to the best D&D campaign in socal.
% Blood of the people!
%

mode_setup;
    if unknown mag: mag := 1; fi;
    mg := 1;
    width# := mg*12pt#;
    height# := mg*12pt#;
    depth# := mg*0pt#;

    thick# := mg*1.5pt#;
    thin# := mg*1.00pt#;

    define_pixels(height, depth, width);
    define_blacker_pixels(thin, thick);

    north := 12/12height;
    south := 0/12height;
    west := 0/12width;
    east := 12/12width;
    hm := 1/2width;
    vm := 6/12height;

    font_size 12pt#;
    font_normal_space width#;
    font_x_height 0;
    font_quad width#;
    font_extra_space width#;

def roundpen =
    pickup pencircle scaled 0.9 thin
enddef;

def double_dotted =
    % numeric x[]; numeric y[];
    z9=(1/2width,1/3height-2/8thin);
    z10=(1/2width,1/3height+2/8thin);
    z11=(1/2width,2/3height-2/8thin);
    z12=(1/2width,2/3height+2/8thin);
    pickup pencircle scaled 0.55 thin;
    % roundpen;
    draw (z9..z10..cycle);
    draw (z11..z12..cycle);
    numeric x[]; numeric y[];
enddef;

def dotted =
    % numeric x[]; numeric y[];
    z9=(1/2width,1/2height-2/8thin);
    z10=(1/2width,1/2height+2/8thin);
    pickup pencircle scaled 0.55 thin;
    % roundpen;
    draw (z9..z10..cycle);
    numeric x[]; numeric y[];
enddef;
PREAMBLE

(('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).each do |letter|
  spec = get_letter_spec(letter)
  next unless spec

  puts 'beginchar("%s", width#, height#, depth#);' % letter
  corner_spec = spec[:corners]
  corners = draw_corners(corner_spec[:vertices])

  vars = corners[:variables]
  order = corners[:order]
  bbox = corners[:bbox]
  cycle = corners[:cycle]

  bbox.each do |corner, var|
    puts "    #{corner.join(' ')} #{var}=(#{vars[var].join(', ')});"
  end

  puts '    roundpen;'
  puts "    draw #{(cycle ? order + [:cycle] : order).join('--')};"

  template = if spec[:fill]
               "draw %1$s;\n    fill %1$s;"
             else
               'draw %s;'
             end

  corner_spec[:triangles].each do |tri|
    if spec[:grid] != :B || !tri.any? {|t| [%i[west north], %i[east south]].include?(t)}
      tri_corners = draw_corners(tri)
      command = tri_corners[:order].map {|var|
        '(%s)' % tri_corners[:variables][var].join(', ')
      }
      command << 'cycle' if tri_corners[:cycle]
      puts "    #{template % command.join('--')}"
    end
  end

  if spec[:grid] == :A
    if letter =~ /[A-Z]/
      puts '    double_dotted;'
    else
      puts '    dotted;'
    end
  elsif spec[:grid] == :B
    corner_spec[:diagonals].each do |tri|
      tri_corners = draw_corners(tri)
      command = tri_corners[:order].map {|var|
        '(%s)' % tri_corners[:variables][var].join(', ')
      }
      command << 'cycle' if tri_corners[:cycle]
      puts "    draw #{command.join('--')};"
    end
  elsif spec[:grid] == :C
    neg_corners = draw_corners(corner_spec[:negative])
    command = neg_corners[:order].map {|var|
      '(%s)' % neg_corners[:variables][var].join(', ')
    }
    command << 'cycle' if neg_corners[:cycle]
    template = "draw %1$s;\n    fill %1$s;"
    puts "    #{template % command.join('--')}"
  end
  puts 'endchar;'
end
puts 'end.'
