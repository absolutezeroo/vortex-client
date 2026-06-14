package com.sulake.core.communication.encryption
{
    import flash.utils.ByteArray;

    public class CryptoTools 
    {

        public static function byteArrayToString(input:ByteArray):String
        {
            input.position = 0;

            var _local_2:String = "";

            while (input.bytesAvailable)
            {
                _local_2 = (_local_2 + String.fromCharCode(input.readByte()));
            };

            return (_local_2);
        }

        public static function stringToByteArray(input:String):ByteArray
        {
            var _local_3:int;
            var _local_2:ByteArray = new ByteArray();
            _local_3 = 0;

            while (_local_3 < input.length)
            {
                _local_2.writeByte(input.charCodeAt(_local_3));
                _local_3++;
            };

            _local_2.position = 0;
            return (_local_2);
        }

        public static function byteArrayToHexString(input:ByteArray, toUpperCase:Boolean=false):String
        {
            var _local_6:uint;
            var _local_3:uint;
            var _local_4:uint;
            input.position = 0;

            var _local_5:String = "";

            while (input.bytesAvailable)
            {
                _local_6 = input.readUnsignedByte();
                _local_3 = (_local_6 >> 4);
                _local_4 = (_local_6 & 0x0F);
                _local_5 = (_local_5 + _local_3.toString(16));
                _local_5 = (_local_5 + _local_4.toString(16));
            };

            if (toUpperCase)
            {
                _local_5 = _local_5.toUpperCase();
            };

            return (_local_5);
        }

        public static function hexStringToByteArray(input:String):ByteArray
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_6:int;
            var _local_5:ByteArray = new ByteArray();

            if ((input.length % 2) != 0)
            {
                input = ("0" + input);
            };

            _local_2 = 0;

            while (_local_2 < (input.length - 1))
            {
                _local_3 = parseInt(input.charAt((_local_2 + 0)), 16);
                _local_4 = parseInt(input.charAt((_local_2 + 1)), 16);
                _local_6 = ((_local_3 << 4) | _local_4);
                _local_5.writeByte(_local_6);
                _local_2++;
                _local_2++;
            };

            return (_local_5);
        }

        public static function BigIntegerToRadix(input:ByteArray, _arg_2:uint=16):String
        {
            return ("");
        }

        public static function fletcher100(input:ByteArray, _arg_2:int, _arg_3:int):int
        {
            var _local_6:int;
            var _local_4:int = _arg_2;
            var _local_5:int = _arg_3;
            _local_6 = 0;

            while (_local_6 < input.length)
            {
                _local_4 = ((_local_4 + input[_local_6]) % 0xFF);
                _local_5 = ((_local_4 + _local_5) % 0xFF);
                _local_6++;
            };

            return ((_local_4 + _local_5) % 100);
        }

    }
}