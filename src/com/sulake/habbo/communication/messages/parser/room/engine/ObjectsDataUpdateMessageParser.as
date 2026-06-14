package com.sulake.habbo.communication.messages.parser.room.engine
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectData;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

        public class ObjectsDataUpdateMessageParser implements IMessageParser
    {

        private var _objects:Array = [];

        public function get objectCount():int
        {
            return (_objects.length);
        }

        public function getObjectData(_arg_1:int):ObjectData
        {
            if (((_arg_1 < 0) || (_arg_1 >= objectCount)))
            {
                return (null);
            };

            return (_objects[_arg_1]);
        }

        public function flush():Boolean
        {
            _objects = [];
            return (true);
        }

        public function parse(_arg_1:IMessageDataWrapper):Boolean
        {
            var _local_4:int;
            var _local_5:int;
            var _local_2:IStuffData;
            var _local_6:int;
            var _local_7:Number;

            if (_arg_1 == null)
            {
                return (false);
            };

            var _local_3:int = _arg_1.readInteger();
            _local_4 = 0;

            while (_local_4 < _local_3)
            {
                _local_5 = _arg_1.readInteger();
                _local_2 = _SafeStr_75.parseStuffData(_arg_1);
                _local_6 = 0;
                _local_7 = parseFloat(_local_2.getLegacyString());

                if (!isNaN(_local_7))
                {
                    _local_6 = int(_local_2.getLegacyString());
                };

                _objects.push(new ObjectData(_local_5, _local_6, _local_2));
                _local_4++;
            };

            return (true);
        }

    }
}