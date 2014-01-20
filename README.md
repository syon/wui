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

# Cursor Control
m = Wui::Mouse.new

m.getPos
# => {:x=>510, :y=>490}

m.setPos(200,200).click.setPos(300,300).click.setPos(400,400).click
```
