package com.sulake.habbo.communication.messages.parser.room.pets
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class PetVocalMessageParser implements IMessageParser
    {

        private var _petObjectId:int = 0;
        private var _petType:int = 0;
        private var _vocalType:String = "";
        private var _vocalIndex:int = 0;

        public function get petObjectId():int
        {
            return (_petObjectId);
        }

        public function get petType():int
        {
            return (_petType);
        }

        public function get vocalType():String
        {
            return (_vocalType);
        }

        public function get vocalIndex():int
        {
            return (_vocalIndex);
        }

        public function flush():Boolean
        {
            _petObjectId = 0;
            _petType = 0;
            _vocalType = "";
            _vocalIndex = 0;
            return (true);
        }

        public function parse(_arg_1:IMessageDataWrapper):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };

            _petObjectId = _arg_1.readInteger();
            _petType = _arg_1.readInteger();
            _vocalType = _arg_1.readString();
            _vocalIndex = _arg_1.readInteger();
            return (true);
        }

    }
}
