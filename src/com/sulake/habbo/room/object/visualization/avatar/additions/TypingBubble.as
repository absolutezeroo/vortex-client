package com.sulake.habbo.room.object.visualization.avatar.additions
{
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

    public class TypingBubble implements IAvatarAddition 
    {

        private var _id:int = -1;
        private var _asset:BitmapDataAsset;
        private var _avatar:AvatarVisualization;
        private var _relativeDepth:Number = 0;

        public function TypingBubble(id:int, avatar:AvatarVisualization)
        {
            _id = id;
            _avatar = avatar;
        }

        public function set relativeDepth(value:Number):void
        {
            _relativeDepth = value;
        }

        public function get id():int
        {
            return (_id);
        }

        public function get disposed():Boolean
        {
            return (_avatar == null);
        }

        public function dispose():void
        {
            _avatar = null;
            _asset = null;
        }

        public function animate(sprite:IRoomObjectSprite):Boolean
        {
            if (((_asset) && (sprite)))
            {
                sprite.asset = (_asset.content as BitmapData);
            };

            return (false);
        }

        public function update(sprite:IRoomObjectSprite, scale:Number):void
        {
            var offsetX:int;
            var offsetY:int;

            if (!sprite)
            {
                return;
            };

            sprite.visible = true;
            sprite.relativeDepth = _relativeDepth;
            sprite.alpha = 0xFF;

            var postureOffset:int = 64;

            if (scale < 48)
            {
                _asset = (_avatar.getAvatarRendererAsset("user_typing_small_png") as BitmapDataAsset);
                offsetX = 3;
                offsetY = -42;
                postureOffset = 32;
            }

            else
            {
                _asset = (_avatar.getAvatarRendererAsset("user_typing_png") as BitmapDataAsset);
                offsetX = 14;
                offsetY = -83;
            };

            if (_avatar.posture == "sit")
            {
                offsetY = int((offsetY + (postureOffset / 2)));
            }

            else
            {
                if (_avatar.posture == "lay")
                {
                    offsetY = (offsetY + postureOffset);
                };
            };

            if (_asset != null)
            {
                sprite.asset = (_asset.content as BitmapData);
                sprite.offsetX = offsetX;
                sprite.offsetY = offsetY;
                sprite.relativeDepth = -0.02;
            };
        }

    }
}
