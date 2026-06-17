package com.sulake.habbo.room.object.visualization.avatar.additions
{
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

    public class ExpressionAddition implements IExpressionAddition 
    {

        protected var _SafeStr_698:int;
        protected var _SafeStr_1265:AvatarVisualization;
        private var _type:int = -1;

        public function ExpressionAddition(id:int, type:int, avatarVisualization:AvatarVisualization)
        {
            _type = type;
            _SafeStr_698 = id;
            _SafeStr_1265 = avatarVisualization;
        }

        public function get type():int
        {
            return (_type);
        }

        public function get id():int
        {
            return (_SafeStr_698);
        }

        public function get disposed():Boolean
        {
            return (_SafeStr_1265 == null);
        }

        public function dispose():void
        {
            _SafeStr_1265 = null;
        }

        public function update(sprite:IRoomObjectSprite, scale:Number):void
        {
        }

        public function animate(sprite:IRoomObjectSprite):Boolean
        {
            return (false);
        }

    }
}
