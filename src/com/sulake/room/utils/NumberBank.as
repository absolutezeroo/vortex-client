package com.sulake.room.utils
{
    public class NumberBank 
    {

        private var _size:int = 0;
        private var _reservedNumbers:Array = [];
        private var _freeNumbers:Array = [];

        public function NumberBank(size:int)
        {
            var _local_2:int;
            super();

            if (size < 0)
            {
                size = 0;
            };

            _local_2 = 0;

            while (_local_2 < size)
            {
                _freeNumbers.push(_local_2);
                _local_2++;
            };
        }

        public function dispose():void
        {
            _reservedNumbers = null;
            _freeNumbers = null;
            _size = 0;
        }

        public function reserveNumber():int
        {
            var _local_1:int;

            if (_freeNumbers.length > 0)
            {
                _local_1 = (_freeNumbers.pop() as int);
                _reservedNumbers.push(_local_1);
                return (_local_1);
            };

            return (-1);
        }

        public function freeNumber(number:int):void
        {
            var _local_2:int = _reservedNumbers.indexOf(number);

            if (_local_2 >= 0)
            {
                _reservedNumbers.splice(_local_2, 1);
                _freeNumbers.push(number);
            };
        }

    }
}

