package com.sulake.habbo.room.object.visualization.avatar.additions
{
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

    public class GameClickTarget implements IAvatarAddition 
    {

        private static const WIDTH:int = 46;
        private static const HEIGHT:int = 60;
        private static const _SafeStr_3237:int = -23;
        private static const _SafeStr_3238:int = -48;

        private var _id:int = -1;
        private var _bitmap:BitmapData;
        private var _disposed:Boolean;

        public function GameClickTarget(id:int)
        {
            _id = id;
        }

        public function get id():int
        {
            return (_id);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                _bitmap = null;
                _disposed = true;
            };
        }

        public function animate(sprite:IRoomObjectSprite):Boolean
        {
            return (false);
        }

        public function update(sprite:IRoomObjectSprite, scale:Number):void
        {
            if (!sprite)
            {
                return;
            };

            if (!_bitmap)
            {
                _bitmap = new BitmapData(46, 60, true, 0);
            };

            sprite.visible = true;
            sprite.asset = _bitmap;
            sprite.offsetX = -23;
            sprite.offsetY = -48;
            sprite.alphaTolerance = -1;
        }

    }
}
