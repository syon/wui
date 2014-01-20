Wui
===

control Windows User Interface with Ruby.

Usage
-----

```ruby
require './wui'

# Window Control
w = Wui::Window.new

w.active("G..gle Chrome")
w.setPos(100, 100)
w.setSize(500, 500)

# Mouse Control
m = Wui::Mouse.new

m.click

p m.getPos
# => {:x=>510, :y=>490}

m.setPos(100, 100) # Absolute X, Y
m.warp(100, 100) # alias setPos
m.to(100, 100) # alias setPos

m.move(50, 50) # Relative X, Y

# Method Chain
m.to(0,0).click.to(200, 0).click.move(0, 200).move(200, 0).move(0, 200)

# o
(-180).step(180, 10).each do |i|
  x = (20 * Math.sin(i * Math::PI / 180.0)).to_i
  y = (20 * Math.cos(i * Math::PI / 180.0)).to_i
  m.move(x, y)
end
```
