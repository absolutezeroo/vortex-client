package com.sulake.habbo.room.object.visualization.data
{
    public class AnimationLayerData 
    {

        private var _frameSequences:Array = [];
        private var _frameCount:int = -1;
        private var _loopCount:int = 1;
        private var _frameRepeat:int = 1;
        private var _isRandom:Boolean = false;

        public function AnimationLayerData(_arg_1:int, _arg_2:int, _arg_3:Boolean)
        {
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            };

            if (_arg_2 < 1)
            {
                _arg_2 = 1;
            };

            _loopCount = _arg_1;
            _frameRepeat = _arg_2;
            _isRandom = _arg_3;
        }

        public function get frameCount():int
        {
            if (_frameCount < 0)
            {
                calculateLength();
            };

            return (_frameCount);
        }

        public function dispose():void
        {
            var _local_2:int;
            var _local_1:AnimationFrameSequenceData;
            _local_2 = 0;

            while (_local_2 < _frameSequences.length)
            {
                _local_1 = (_frameSequences[_local_2] as AnimationFrameSequenceData);

                if (_local_1 != null)
                {
                    _local_1.dispose();
                };

                _local_2++;
            };

            _frameSequences = [];
        }

        public function addFrameSequence(_arg_1:int, _arg_2:Boolean):AnimationFrameSequenceData
        {
            var _local_3:AnimationFrameSequenceData = new AnimationFrameSequenceData(_arg_1, _arg_2);
            _frameSequences.push(_local_3);
            return (_local_3);
        }

        public function calculateLength():void
        {
            var _local_2:int;
            var _local_1:AnimationFrameSequenceData;
            _frameCount = 0;
            _local_2 = 0;

            while (_local_2 < _frameSequences.length)
            {
                _local_1 = (_frameSequences[_local_2] as AnimationFrameSequenceData);

                if (_local_1 != null)
                {
                    _frameCount = (_frameCount + _local_1.frameCount);
                };

                _local_2++;
            };
        }

        public function getFrame(_arg_1:int, _arg_2:int):AnimationFrame
        {
            var _local_7:int;
            var _local_6:int;

            if (_frameCount < 1)
            {
                return (null);
            };

            var _local_4:AnimationFrameSequenceData;
            _arg_2 = int((_arg_2 / _frameRepeat));

            var _local_5:Boolean;
            var _local_3:int;

            if (!_isRandom)
            {
                _local_7 = int((_arg_2 / _frameCount));
                _arg_2 = (_arg_2 % _frameCount);

                if ((((_loopCount > 0) && (_local_7 >= _loopCount)) || ((_loopCount <= 0) && (_frameCount == 1))))
                {
                    _arg_2 = (_frameCount - 1);
                    _local_5 = true;
                };

                _local_6 = 0;
                _local_3 = 0;

                while (_local_3 < _frameSequences.length)
                {
                    _local_4 = (_frameSequences[_local_3] as AnimationFrameSequenceData);

                    if (_local_4 != null)
                    {
                        if (_arg_2 < (_local_6 + _local_4.frameCount)) break;
                        _local_6 = (_local_6 + _local_4.frameCount);
                    };

                    _local_3++;
                };

                return (getFrameFromSpecificSequence(_arg_1, _local_4, _local_3, (_arg_2 - _local_6), _local_5));
            };

            _local_3 = int((_frameSequences.length * Math.random()));
            _local_4 = (_frameSequences[_local_3] as AnimationFrameSequenceData);

            if (_local_4.frameCount < 1)
            {
                return (null);
            };

            _arg_2 = 0;
            return (getFrameFromSpecificSequence(_arg_1, _local_4, _local_3, _arg_2, false));
        }

        public function getFrameFromSequence(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):AnimationFrame
        {
            if (((_arg_2 < 0) || (_arg_2 >= _frameSequences.length)))
            {
                return (null);
            };

            var _local_5:AnimationFrameSequenceData = (_frameSequences[_arg_2] as AnimationFrameSequenceData);

            if (_local_5 != null)
            {
                if (_arg_3 >= _local_5.frameCount)
                {
                    return (getFrame(_arg_1, _arg_4));
                };

                return (getFrameFromSpecificSequence(_arg_1, _local_5, _arg_2, _arg_3, false));
            };

            return (null);
        }

        private function getFrameFromSpecificSequence(_arg_1:int, _arg_2:AnimationFrameSequenceData, _arg_3:int, _arg_4:int, _arg_5:Boolean):AnimationFrame
        {
            var _local_10:int;
            var _local_8:AnimationFrameData;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_7:int;
            var _local_6:int;
            var _local_9:Boolean;
            var _local_15:AnimationFrame;

            if (_arg_2 != null)
            {
                _local_10 = _arg_2.getFrameIndex(_arg_4);
                _local_8 = _arg_2.getFrame(_local_10);

                if (_local_8 == null)
                {
                    return (null);
                };

                _local_11 = _local_8.getX(_arg_1);
                _local_12 = _local_8.getY(_arg_1);
                _local_13 = _local_8.randomX;
                _local_14 = _local_8.randomY;

                if (_local_13 != 0)
                {
                    _local_11 = int((_local_11 + (_local_13 * Math.random())));
                };

                if (_local_14 != 0)
                {
                    _local_12 = int((_local_12 + (_local_14 * Math.random())));
                };

                _local_7 = _local_8.repeats;

                if (_local_7 > 1)
                {
                    _local_7 = _arg_2.getRepeats(_local_10);
                };

                _local_6 = (_frameRepeat * _local_7);

                if (_arg_5)
                {
                    _local_6 = -1;
                };

                _local_9 = false;

                if (((!(_isRandom)) && (!(_arg_2.isRandom))))
                {
                    if (((_arg_3 == (_frameSequences.length - 1)) && (_arg_4 == (_arg_2.frameCount - 1))))
                    {
                        _local_9 = true;
                    };
                };

                _local_15 = AnimationFrame.allocate(_local_8.id, _local_11, _local_12, _local_7, _local_6, _local_9, _arg_3, _arg_4);
                return (_local_15);
            };

            return (null);
        }

    }
}
