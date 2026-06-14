package com.sulake.habbo.room.object.visualization.furniture
{
    public class FurnitureValRandomizerVisualization extends AnimatedFurnitureVisualization 
    {

        private static const ANIMATION_ID_OFFSET_SLOW1:int = 20;
        private static const ANIMATION_ID_OFFSET_SLOW2:int = 10;
        private static const _SafeStr_3313:int = 31;
        private static const _SafeStr_3299:int = 32;
        private static const _SafeStr_3367:int = 30;

        private var _stateQueue:Array = [];
        private var _running:Boolean = false;

        public function FurnitureValRandomizerVisualization()
        {
            super.setAnimation(30);
        }

        override protected function setAnimation(_arg_1:int):void
        {
            if (_arg_1 == 0)
            {
                if (!_running)
                {
                    _running = true;
                    _stateQueue = [];
                    _stateQueue.push(31);
                    _stateQueue.push(32);
                    return;
                };
            };

            if (((_arg_1 > 0) && (_arg_1 <= 10)))
            {
                if (_running)
                {
                    _running = false;
                    _stateQueue = [];

                    if (direction == 2)
                    {
                        _stateQueue.push(((20 + 5) - _arg_1));
                        _stateQueue.push(((10 + 5) - _arg_1));
                    }

                    else
                    {
                        _stateQueue.push((20 + _arg_1));
                        _stateQueue.push((10 + _arg_1));
                    };

                    _stateQueue.push(30);
                    return;
                };

                super.setAnimation(30);
            };
        }

        override protected function updateAnimation(_arg_1:Number):int
        {
            if (super.getLastFramePlayed(11))
            {
                if (_stateQueue.length > 0)
                {
                    super.setAnimation(_stateQueue.shift());
                };
            };

            return (super.updateAnimation(_arg_1));
        }

    }
}
