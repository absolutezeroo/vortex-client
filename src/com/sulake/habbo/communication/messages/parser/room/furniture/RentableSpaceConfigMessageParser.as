package com.sulake.habbo.communication.messages.parser.room.furniture
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class RentableSpaceConfigMessageParser implements IMessageParser
    {

        private var _furnitureId:int;
        private var _isConfigured:Boolean;
        private var _price:int;
        private var _currencyTypeId:int;
        private var _rentDurationSeconds:int;
        private var _requiresHc:Boolean;
        private var _currencies:Array;

        public function flush():Boolean
        {
            _currencies = [];
            return (true);
        }

        public function parse(_arg_1:IMessageDataWrapper):Boolean
        {
            _furnitureId = _arg_1.readInteger();
            _isConfigured = _arg_1.readBoolean();
            _price = _arg_1.readInteger();
            _currencyTypeId = _arg_1.readInteger();
            _rentDurationSeconds = _arg_1.readInteger();
            _requiresHc = _arg_1.readBoolean();

            var count:int = _arg_1.readInteger();
            _currencies = [];

            for (var i:int = 0; i < count; i++)
            {
                _currencies.push({ id: _arg_1.readInteger(), name: _arg_1.readString() });
            }

            return (true);
        }

        public function get furnitureId():int
        {
            return (_furnitureId);
        }

        public function get isConfigured():Boolean
        {
            return (_isConfigured);
        }

        public function get price():int
        {
            return (_price);
        }

        public function get currencyTypeId():int
        {
            return (_currencyTypeId);
        }

        public function get rentDurationSeconds():int
        {
            return (_rentDurationSeconds);
        }

        public function get requiresHc():Boolean
        {
            return (_requiresHc);
        }

        public function get currencies():Array
        {
            return (_currencies);
        }

    }
}
