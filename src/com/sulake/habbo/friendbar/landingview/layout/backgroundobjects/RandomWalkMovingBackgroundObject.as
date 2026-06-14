package com.sulake.habbo.friendbar.landingview.layout.backgroundobjects
{
    import com.sulake.core.window.IWindowContainer;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.habbo.utils._SafeStr_25;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.events.PathResetEvent;

    public class RandomWalkMovingBackgroundObject extends BackgroundObject 
    {

        private var _startX:int;
        private var _startY:int;
        private var _randomX:Number;
        private var _randomY:Number;
        private var _speedX:Number;
        private var _speedY:Number;
        private var _randomTimeSpan:Number;
        private var _timer:uint = 0;
        private var _posX:Number;
        private var _posY:Number;
        private var _nextRandomX:Number = 0;
        private var _nextRandomY:Number = 0;
        private var _currentRandomX:Number = 0;
        private var _currentRandomY:Number = 0;
        private var _lastSample:uint;

        public function RandomWalkMovingBackgroundObject(_arg_1:int, _arg_2:IWindowContainer, _arg_3:EventDispatcher, _arg_4:HabboLandingView, _arg_5:String)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, false);

            var _local_7:Array = _arg_5.split(";");
            var _local_6:String = _local_7[0];
            _startX = _local_7[2];
            _startY = _local_7[3];
            _speedX = _local_7[4];
            _speedY = _local_7[5];
            _randomX = _local_7[6];
            _randomY = _local_7[7];
            _randomTimeSpan = _local_7[8];
            _posX = _startX;
            _posY = _startY;
            sprite.assetUri = (("${image.library.url}" + _local_6) + ".png");
        }

        override public function update(_arg_1:uint):void
        {
            super.update(_arg_1);

            if (!sprite)
            {
                return;
            };

            _timer = (_timer + _arg_1);

            if ((_timer - _lastSample) > _randomTimeSpan)
            {
                _currentRandomX = _nextRandomX;
                _currentRandomY = _nextRandomY;
                _nextRandomX = (((Math.random() * 2) - 1) * _randomX);
                _nextRandomY = (((Math.random() * 2) - 1) * _randomY);
                _lastSample = _timer;
            };

            var _local_4:int = window.width;
            var _local_2:int = window.height;
            var _local_3:Number = ((_timer - _lastSample) / _randomTimeSpan);
            _posX = (_posX + ((_arg_1 / 1000) * (_speedX + _SafeStr_25.lerp(_local_3, _currentRandomX, _nextRandomX))));
            _posY = (_posY + ((_arg_1 / 1000) * (_speedY + _SafeStr_25.lerp(_local_3, _currentRandomY, _nextRandomY))));
            sprite.x = _posX;
            sprite.y = _posY;

            if ((((((_speedX > 0) && (sprite.x > _local_4)) || ((_speedX < 0) && ((sprite.x + sprite.width) < 0))) || ((_speedY > 0) && (sprite.y > _local_2))) || ((_speedY < 0) && ((sprite.y + sprite.height) < 0))))
            {
                _posX = _startX;
                _posY = _startY;
                events.dispatchEvent(new PathResetEvent("LWMOPRE_MOVING_OBJECT_PATH_RESET", id));
            };
        }

    }
}
