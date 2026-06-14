package com.sulake.habbo.utils
{
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.Timer;
    import com.sulake.core.window.components.IIconWindow;
    import flash.events.Event;

    public class LoadingIcon implements IDisposable 
    {

        private static const FRAMES:Array = [23, 24, 25, 26];

        private var _timer:Timer = new Timer(160);
        private var _icon:IIconWindow;
        private var _frameIndex:int;

        public function LoadingIcon()
        {
            _timer.addEventListener("timer", onTimer);
        }

        public function dispose():void
        {
            if (_timer)
            {
                _timer.removeEventListener("timer", onTimer);
                _timer.stop();
                _timer = null;
            };

            _icon = null;
        }

        public function get disposed():Boolean
        {
            return (_timer == null);
        }

        public function setVisible(_arg_1:IIconWindow, _arg_2:Boolean):void
        {
            _icon = _arg_1;
            _icon.visible = _arg_2;

            if (_arg_2)
            {
                _icon.style = FRAMES[_frameIndex];
                _timer.start();
            }

            else
            {
                _timer.stop();
            };
        }

        private function onTimer(_arg_1:Event):void
        {
            if (_icon == null)
            {
                return;
            };

            _frameIndex++;

            if (_frameIndex >= FRAMES.length)
            {
                _frameIndex = 0;
            };

            _icon.style = FRAMES[_frameIndex];
        }

    }
}
