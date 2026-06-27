package com.sulake.habbo.communication.messages.outgoing.room.furniture
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class ConfigureRentableSpaceMessageComposer implements IMessageComposer
    {

        private var _data:Array;

        public function ConfigureRentableSpaceMessageComposer(_furniId:int, _price:int, _currencyTypeId:int, _rentDurationSeconds:int, _requiresHc:Boolean)
        {
            _data = [_furniId, _price, _currencyTypeId, _rentDurationSeconds, _requiresHc];
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
