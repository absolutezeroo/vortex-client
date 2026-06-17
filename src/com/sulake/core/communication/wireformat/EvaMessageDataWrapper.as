package com.sulake.core.communication.wireformat
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import flash.utils.ByteArray;
    import com.hurlant.util._SafeStr_15;

        internal final class EvaMessageDataWrapper implements IMessageDataWrapper 
    {

        private var _id:int;
        private var _data:ByteArray;

        public function EvaMessageDataWrapper(_arg_1:int, _arg_2:ByteArray)
        {
            _id = _arg_1;
            _data = _arg_2;
        }

        public function getID():int
        {
            return (_id);
        }

        public function readString():String
        {
            return (_data.readUTF());
        }

        public function readInteger():int
        {
            return (_data.readInt());
        }

        public function readLong():Number
        {
            var _local_1:int = _data.readInt();
            var _local_2:uint = _data.readUnsignedInt();
            return ((_local_1 * 4294967296) + _local_2);
        }

        public function readBoolean():Boolean
        {
            return (_data.readBoolean());
        }

        public function readShort():int
        {
            return (_data.readShort());
        }

        public function readByte():int
        {
            return (_data.readByte());
        }

        public function readFloat():Number
        {
            return (_data.readFloat());
        }

        public function readDouble():Number
        {
            return (_data.readDouble());
        }

        public function get bytesAvailable():uint
        {
            return (_data.bytesAvailable);
        }

        public function toString():String
        {
            return ((((("id=" + _id) + ", pos=") + _data.position) + ", data=") + _SafeStr_15.fromArray(_data, true));
        }

    }
}
