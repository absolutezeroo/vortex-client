package com.sulake.habbo.quest
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;

    public class Animation implements IDisposable 
    {

        private var _canvas:IBitmapWrapperWindow;
        private var _timeElapsedSinceStart:int;
        private var _playing:Boolean;
        private var _sprites:Array = [];

        public function Animation(_arg_1:IBitmapWrapperWindow)
        {
            _canvas = _arg_1;
            _canvas.visible = false;

            if (_arg_1.bitmap == null)
            {
                _arg_1.bitmap = new BitmapData(_arg_1.width, _arg_1.height, true, 0);
            };
        }

        public function dispose():void
        {
            _canvas = null;

            if (_sprites)
            {
                for each (var _local_1:AnimationObject in _sprites)
                {
                    _local_1.dispose();
                };

                _sprites = null;
            };
        }

        public function get disposed():Boolean
        {
            return (_canvas == null);
        }

        public function addObject(_arg_1:AnimationObject):void
        {
            _sprites.push(_arg_1);
        }

        public function stop():void
        {
            _playing = false;
            _canvas.visible = false;
        }

        public function restart():void
        {
            _timeElapsedSinceStart = 0;
            _playing = true;

            for each (var _local_1:AnimationObject in _sprites)
            {
                _local_1.onAnimationStart();
            };

            draw();
            _canvas.visible = true;
        }

        public function update(_arg_1:uint):void
        {
            if (_playing)
            {
                _timeElapsedSinceStart = (_timeElapsedSinceStart + _arg_1);
                draw();
            };
        }

        private function draw():void
        {
            var _local_1:Boolean;
            var _local_3:BitmapData;
            _canvas.bitmap.fillRect(_canvas.bitmap.rect, 0);

            if (_playing)
            {
                _local_1 = false;

                for each (var _local_2:AnimationObject in _sprites)
                {
                    if (!_local_2.isFinished(_timeElapsedSinceStart))
                    {
                        _local_1 = true;
                        _local_3 = _local_2.getBitmap(_timeElapsedSinceStart);

                        if (_local_3 != null)
                        {
                            _canvas.bitmap.copyPixels(_local_3, _local_3.rect, _local_2.getPosition(_timeElapsedSinceStart));
                        };
                    };
                };
            };

            _canvas.invalidate();
            _playing = _local_1;
        }

    }
}
