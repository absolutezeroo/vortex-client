package com.sulake.room.events
{
    public class RoomSpriteMouseEvent 
    {

        private var _type:String = "";
        private var _eventId:String = "";
        private var _canvasId:String = "";
        private var _spriteTag:String = "";
        private var _screenX:Number = 0;
        private var _screenY:Number = 0;
        private var _localX:Number = 0;
        private var _localY:Number = 0;
        private var _ctrlKey:Boolean = false;
        private var _altKey:Boolean = false;
        private var _shiftKey:Boolean = false;
        private var _buttonDown:Boolean = false;
        private var _spriteOffsetX:int = 0;
        private var _spriteOffsetY:int = 0;

        public function RoomSpriteMouseEvent(type:String, eventId:String, canvasId:String, spriteTag:String, screenX:Number, screenY:Number, localX:Number=0, localY:Number=0, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false)
        {
            _type = type;
            _eventId = eventId;
            _canvasId = canvasId;
            _spriteTag = spriteTag;
            _screenX = screenX;
            _screenY = screenY;
            _localX = localX;
            _localY = localY;
            _ctrlKey = ctrlKey;
            _altKey = altKey;
            _shiftKey = shiftKey;
            _buttonDown = buttonDown;
        }

        public function get type():String
        {
            return (_type);
        }

        public function get eventId():String
        {
            return (_eventId);
        }

        public function get canvasId():String
        {
            return (_canvasId);
        }

        public function get spriteTag():String
        {
            return (_spriteTag);
        }

        public function get screenX():Number
        {
            return (_screenX);
        }

        public function get screenY():Number
        {
            return (_screenY);
        }

        public function get localX():Number
        {
            return (_localX);
        }

        public function get localY():Number
        {
            return (_localY);
        }

        public function get ctrlKey():Boolean
        {
            return (_ctrlKey);
        }

        public function get altKey():Boolean
        {
            return (_altKey);
        }

        public function get shiftKey():Boolean
        {
            return (_shiftKey);
        }

        public function get buttonDown():Boolean
        {
            return (_buttonDown);
        }

        public function get spriteOffsetX():int
        {
            return (_spriteOffsetX);
        }

        public function set spriteOffsetX(spriteOffsetX:int):void
        {
            _spriteOffsetX = spriteOffsetX;
        }

        public function get spriteOffsetY():int
        {
            return (_spriteOffsetY);
        }

        public function set spriteOffsetY(spriteOffsetY:int):void
        {
            _spriteOffsetY = spriteOffsetY;
        }

    }
}
