require 'ruby-sdl-ffi'

A, B, C    = [5, 1, 20]
XRES, YRES = 350, 350
SCREEN     = SDL.SetVideoMode(XRES, YRES, 0, 0)

def f(p)
  x,y = p
  [g(p), A - x]
end

def g(p)
  x,y = p
  y - ((x <=> 0) * Math.sqrt((B * x - C).abs))
end

def center(p)
  x,y = p
  [x + (XRES / 2), (YRES / 2) + y]
end

S = SDL.CreateRGBSurface(SDL::SWSURFACE, 1,1,32,0,0,0,0)

def draw(p)
  r   = SDL::Rect.new( :x=>0, :y=>0, :w=>1, :h=>1 )
  rgb = (Time.now.to_f.modulo(1) * 0xFFFF).round
  SDL.FillRect(S, r, rgb)
  r.x, r.y = center p
  SDL.BlitSurface(S, nil, SCREEN, r)
  SDL.Flip SCREEN if r.x % 5 == 0
  f p
end

iterate = -> (x, &block) do
  Enumerator.new do |f|
    loop do
      f << x
      x = block.call(x)
    end
  end.lazy
end

set = iterate.call([0,0]) { |p| draw(p) }.first 599999

SDL.Flip SCREEN
SDL.SaveBMP(SCREEN, "out.bmp")
