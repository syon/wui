# Ruby 1.9.3
require 'dl/import'

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

    def click
      mouseEvent(0x0002) # MOUSEEVENTF_LEFTDOWN
      sleep 0.2
      mouseEvent(0x0004) # MOUSEEVENTF_LEFTUP
      self
    end

    private

    def mouseEvent(event, x=0, y=0, w=0)
      Wui.mouse_event(event, x, y, w, 0)
    end
  end

end