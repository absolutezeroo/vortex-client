package com.sulake.habbo.utils
{
    public class FixedSizeStack 
    {

        private var _data:Array = [];
        private var _maxSize:int = 0;
        private var _index:int = 0;

        public function FixedSizeStack(_arg_1:int)
        {
            _maxSize = _arg_1;
        }

        public function reset():void
        {
            _data = [];
            _index = 0;
        }

        public function addValue(_arg_1:int):void
        {
            if (_data.length < _maxSize)
            {
                _data.push(_arg_1);
            }

            else
            {
                _data[_index] = _arg_1;
            };

            _index = ((_index + 1) % _maxSize);
        }

        public function getMax():int
        {
            var _local_1:int;
            var _local_2:int = -2147483648;
            _local_1 = 0;

            while (_local_1 < _maxSize)
            {
                if (_data[_local_1] > _local_2)
                {
                    _local_2 = _data[_local_1];
                };

                _local_1++;
            };

            return (_local_2);
        }

        public function getMin():int
        {
            var _local_1:int;
            var _local_2:int = 2147483647;
            _local_1 = 0;

            while (_local_1 < _maxSize)
            {
                if (_data[_local_1] < _local_2)
                {
                    _local_2 = _data[_local_1];
                };

                _local_1++;
            };

            return (_local_2);
        }

    }
}
