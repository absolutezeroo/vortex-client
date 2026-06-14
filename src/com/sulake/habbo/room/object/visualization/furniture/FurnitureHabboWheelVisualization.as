package com.sulake.habbo.room.object.visualization.furniture
{
    public class FurnitureHabboWheelVisualization extends AnimatedFurnitureVisualization 
    {

        private static const ANIMATION_ID_OFFSET_SLOW1:int = 10;
        private static const ANIMATION_ID_OFFSET_SLOW2:int = 20;
        private static const _SafeStr_3313:int = 31;
        private static const _SafeStr_3299:int = 32;

        private var _stateQueue:Array = [];
        private var _running:Boolean = false;

        override protected function setAnimation(_arg_1:int):void
        {
            if (_arg_1 == -1)
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
                    _stateQueue.push((10 + _arg_1));
                    _stateQueue.push((20 + _arg_1));
                    _stateQueue.push(_arg_1);
                    return;
                };

                super.setAnimation(_arg_1);
            };
        }

        override protected function updateAnimation(_arg_1:Number):int
        {
            if ((((super.getLastFramePlayed(1)) && (super.getLastFramePlayed(2))) && (super.getLastFramePlayed(3))))
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
