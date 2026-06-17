package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.Vector3d;

    public class RoomObjectTileCursorUpdateMessage extends RoomObjectUpdateMessage 
    {

        private var _height:Number;
        private var _sourceEventId:String;
        private var _visible:Boolean;
        private var _toggleVisibility:Boolean;

        public function RoomObjectTileCursorUpdateMessage(location:Vector3d, height:Number, visible:Boolean, sourceEventId:String, toggleVisibility:Boolean=false)
        {
            super(location, null);
            _height = height;
            _visible = visible;
            _sourceEventId = sourceEventId;
            _toggleVisibility = toggleVisibility;
        }

        public function get height():Number
        {
            return (_height);
        }

        public function get visible():Boolean
        {
            return (_visible);
        }

        public function get sourceEventId():String
        {
            return (_sourceEventId);
        }

        public function get toggleVisibility():Boolean
        {
            return (_toggleVisibility);
        }

    }
}