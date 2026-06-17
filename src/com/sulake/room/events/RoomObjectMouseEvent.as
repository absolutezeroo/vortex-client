package com.sulake.room.events
{
    import com.sulake.room.object.IRoomObject;

    public class RoomObjectMouseEvent extends RoomObjectEvent 
    {

        public static const ROOM_OBJECT_MOUSE_CLICK:String = "ROE_MOUSE_CLICK";
        public static const ROOM_OBJECT_MOUSE_ENTER:String = "ROE_MOUSE_ENTER";
        public static const ROOM_OBJECT_MOUSE_MOVE:String = "ROE_MOUSE_MOVE";
        public static const ROOM_OBJECT_MOUSE_LEAVE:String = "ROE_MOUSE_LEAVE";
        public static const ROOM_OBJECT_MOUSE_DOUBLE_CLICK:String = "ROE_MOUSE_DOUBLE_CLICK";
        public static const ROOM_OBJECT_MOUSE_DOWN:String = "ROE_MOUSE_DOWN";

        private var _eventId:String = "";
        private var _altKey:Boolean;
        private var _ctrlKey:Boolean;
        private var _shiftKey:Boolean;
        private var _buttonDown:Boolean;
        private var _localX:int;
        private var _localY:int;
        private var _spriteOffsetX:int;
        private var _spriteOffsetY:int;

        public function RoomObjectMouseEvent(type:String, roomObject:IRoomObject, eventId:String, altKey:Boolean=false, ctrlKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, roomObject, bubbles, cancelable);
            _eventId = eventId;
            _altKey = altKey;
            _ctrlKey = ctrlKey;
            _shiftKey = shiftKey;
            _buttonDown = buttonDown;
        }

        public function get eventId():String
        {
            return (_eventId);
        }

        public function get altKey():Boolean
        {
            return (_altKey);
        }

        public function get ctrlKey():Boolean
        {
            return (_ctrlKey);
        }

        public function get shiftKey():Boolean
        {
            return (_shiftKey);
        }

        public function get buttonDown():Boolean
        {
            return (_buttonDown);
        }

        public function get localX():int
        {
            return (_localX);
        }

        public function get localY():int
        {
            return (_localY);
        }

        public function get spriteOffsetX():int
        {
            return (_spriteOffsetX);
        }

        public function get spriteOffsetY():int
        {
            return (_spriteOffsetY);
        }

        public function set localX(localX:int):void
        {
            _localX = localX;
        }

        public function set localY(localY:int):void
        {
            _localY = localY;
        }

        public function set spriteOffsetX(spriteOffsetX:int):void
        {
            _spriteOffsetX = spriteOffsetX;
        }

        public function set spriteOffsetY(spriteOffsetY:int):void
        {
            _spriteOffsetY = spriteOffsetY;
        }

    }
}
