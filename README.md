# Wui

Windows UI controls for Ruby

## Installation

Add this line to your application's Gemfile:

    gem 'wui'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wui

## Usage

```ruby
require 'wui'

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
m.to(0, 0).click.to(200, 0).click.move(0, 200).move(200, 0).move(0, 200)

# o
(-180).step(180, 10).each do |i|
  x = (20 * Math.sin(i * Math::PI / 180.0)).to_i
  y = (20 * Math.cos(i * Math::PI / 180.0)).to_i
  m.move(x, y)
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
