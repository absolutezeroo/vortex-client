package com.sulake.habbo.communication.messages.outgoing.room.furniture
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class GetRentableSpaceConfigMessageComposer implements IMessageComposer
    {

        private var _data:Array;

        public function GetRentableSpaceConfigMessageComposer(_arg_1:int)
        {
            _data = [_arg_1];
        }

        public function getMessageArray():Array
        {
            return (_data);
        }

        public function dispose():void
        {
            _data = null;
        }

    }
}
