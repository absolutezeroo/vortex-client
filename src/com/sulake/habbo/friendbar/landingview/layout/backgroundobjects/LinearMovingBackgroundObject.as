package com.sulake.habbo.friendbar.landingview.layout.backgroundobjects
{
    import com.sulake.core.window.IWindowContainer;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.events.PathResetEvent;

    public class LinearMovingBackgroundObject extends BackgroundObject 
    {

        private var _startX:int;
        private var _startY:int;
        private var _posX:Number;
        private var _posY:Number;
        private var _speedX:Number;
        private var _speedY:Number;

        public function LinearMovingBackgroundObject(_arg_1:int, _arg_2:IWindowContainer, _arg_3:EventDispatcher, _arg_4:HabboLandingView, _arg_5:String)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);

            var _local_7:Array = _arg_5.split(";");
            var _local_6:String = _local_7[0];
            _startX = _local_7[2];
            _startY = _local_7[3];
            _speedX = _local_7[4];
            _speedY = _local_7[5];
            _posX = _startX;
            _posY = _startY;
            sprite.assetUri = (("${image.library.url}reception/" + _local_6) + ".png");
        }

        override public function update(_arg_1:uint):void
        {
            super.update(_arg_1);

            if (!sprite)
            {
                return;
            };

            var _local_3:int = window.width;
            var _local_2:int = window.height;
            _posX = (_posX + (_arg_1 * _speedX));
            _posY = (_posY + (_arg_1 * _speedY));
            sprite.x = _posX;
            sprite.y = (_posY + window.desktop.height);

            if ((((((_speedX > 0) && (sprite.x > _local_3)) || ((_speedX < 0) && ((sprite.x + sprite.width) < 0))) || ((_speedY > 0) && (sprite.y > _local_2))) || ((_speedY < 0) && ((sprite.y + sprite.height) < 0))))
            {
                _posX = _startX;
                _posY = _startY;
                events.dispatchEvent(new PathResetEvent("LWMOPRE_MOVING_OBJECT_PATH_RESET", id));
            };
        }

    }
}
