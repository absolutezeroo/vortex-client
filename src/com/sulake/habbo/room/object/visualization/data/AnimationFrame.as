package com.sulake.habbo.room.object.visualization.data
{
    public class AnimationFrame 
    {

        public static const FRAME_REPEAT_FOREVER:int = -1;
        public static const _SafeStr_3275:int = -1;
        private static const POOL_SIZE_LIMIT:int = 3000;
        private static const _SafeStr_1036:Array = [];

        private var _id:int = 0;
        private var _x:int = 0;
        private var _y:int = 0;
        private var _repeats:int = 1;
        private var _frameRepeats:int = 1;
        private var _remainingFrameRepeats:int = 1;
        private var _activeSequence:int = -1;
        private var _activeSequenceOffset:int = 0;
        private var _isLastFrame:Boolean = false;
        private var _isRecycled:Boolean = false;

        public static function allocate(id:int, x:int, y:int, repeats:int, frameRepeats:int, isLastFrame:Boolean, activeSequence:int=-1, activeSequenceOffset:int=0):AnimationFrame
        {
            var frame:AnimationFrame = ((_SafeStr_1036.length > 0) ? _SafeStr_1036.pop() : new AnimationFrame());
            frame._isRecycled = false;
            frame._id = id;
            frame._x = x;
            frame._y = y;
            frame._isLastFrame = isLastFrame;

            if (repeats < 1)
            {
                repeats = 1;
            };

            frame._repeats = repeats;

            if (frameRepeats < 0)
            {
                frameRepeats = -1;
            };

            frame._frameRepeats = frameRepeats;
            frame._remainingFrameRepeats = frameRepeats;

            if (activeSequence >= 0)
            {
                frame._activeSequence = activeSequence;
                frame._activeSequenceOffset = activeSequenceOffset;
            };

            return (frame);
        }

        public function get id():int
        {
            if (_id >= 0)
            {
                return (_id);
            };

            return (-(_id) * Math.random());
        }

        public function get x():int
        {
            return (_x);
        }

        public function get y():int
        {
            return (_y);
        }

        public function get repeats():int
        {
            return (_repeats);
        }

        public function get frameRepeats():int
        {
            return (_frameRepeats);
        }

        public function get isLastFrame():Boolean
        {
            return (_isLastFrame);
        }

        public function get remainingFrameRepeats():int
        {
            if (_frameRepeats < 0)
            {
                return (-1);
            };

            return (_remainingFrameRepeats);
        }

        public function set remainingFrameRepeats(value:int):void
        {
            if (value < 0)
            {
                value = 0;
            };

            if (((_frameRepeats > 0) && (value > _frameRepeats)))
            {
                value = _frameRepeats;
            };

            _remainingFrameRepeats = value;
        }

        public function get activeSequence():int
        {
            return (_activeSequence);
        }

        public function get activeSequenceOffset():int
        {
            return (_activeSequenceOffset);
        }

        public function recycle():void
        {
            if (!_isRecycled)
            {
                _isRecycled = true;

                if (_SafeStr_1036.length < 3000)
                {
                    _SafeStr_1036.push(this);
                };
            };
        }

    }
}
