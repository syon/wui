require "wui/version"
require 'dl/import'
require 'easing'

module Wui

  extend DL::Importer
  dlload 'User32'
  extern 'int GetForegroundWindow()'
  extern 'void SetForegroundWindow(int)'
  extern 'int EnumWindows(void*, int)'
  extern 'int GetWindowText(int, char*, int)'
  extern 'int SetWindowPos(int, int, int, int, int, int, int)'
  extern 'void GetCursorPos(char*)'
  extern 'void SetCursorPos(int, int)'
  extern 'void mouse_event(int, int, int, int, int)'

  class Window
    def active(title)
      setWindowHandle(title)
      checkHWND
      Wui.SetForegroundWindow(@hWnd)
      self
    end

    def setPos(x, y)
      checkHWND
      Wui.SetWindowPos(@hWnd, 0, x, y, 0, 0, 1) # SWP_NOSIZE
      self
    end

    def setSize(w, h)
      checkHWND
      Wui.SetWindowPos(@hWnd, 0, 0, 0, w, h, 2) # SWP_NOMOVE
      self
    end

    private

    def checkHWND
      @hWnd = Wui.GetForegroundWindow() if @hWnd.nil?
    end

    def getWindowText(hWnd)
      buf = ' '*128
      Wui.GetWindowText(hWnd, buf, buf.size) # title -> buf
      buf
    end

    def setWindowHandle(title)
      @hWnd = nil
      @query = title
      @ewProc = DL::Function.new(DL::CFunc.new(0, DL::TYPE_INT), [DL::TYPE_INT], &method(:ewProcCallback))
      Wui.EnumWindows(@ewProc, 0)
    end

    def ewProcCallback(hWnd)
      text = getWindowText(hWnd)
      if /#{@query}/ =~ text
        @hWnd = hWnd
        @title = text.strip
        0 # zero to stop
      else
        -1 # continue EnumWindows loop
      end
    end
  end

  class Mouse

    def getPos
      lpP=" "*8
      Wui.GetCursorPos(lpP)
      xy = lpP.unpack("LL")
      {:x=> xy[0], :y=> xy[1]}
    end

    def setPos(x, y)
      Wui.SetCursorPos(x, y)
      self
    end

    alias warp setPos
    alias to setPos

    def move(dx, dy)
      easePos(dx, dy, false)
      self
    end

    def click
      mouseEvent(0x0002) # MOUSEEVENTF_LEFTDOWN
      sleep 0.2
      mouseEvent(0x0004) # MOUSEEVENTF_LEFTUP
      self
    end

    private

    def easePos(x, y, abs=true)
      d = 20
      from = getPos
      if abs
        xm = (0..d).map { |t| Easing.ease_in_out_expo(t, from[:x], x-from[:x], d) }
        ym = (0..d).map { |t| Easing.ease_in_out_expo(t, from[:y], y-from[:y], d) }
      else
        xm = (0..d).map { |t| Easing.ease_in_out_expo(t, from[:x], x, d) }
        ym = (0..d).map { |t| Easing.ease_in_out_expo(t, from[:y], y, d) }
      end
      (0..d).map { |t| sleep 0.01; Wui.SetCursorPos(xm[t], ym[t]) }
      self
    end

    def mouseEvent(event, x=0, y=0, w=0)
      Wui.mouse_event(event, x, y, w, 0)
    end
  end

end
