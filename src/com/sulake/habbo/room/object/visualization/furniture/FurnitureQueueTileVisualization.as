package com.sulake.habbo.room.object.visualization.furniture
{
    public class FurnitureQueueTileVisualization extends AnimatedFurnitureVisualization 
    {

        private static const _SafeStr_3299:int = 3;
        private static const _SafeStr_3356:int = 2;
        private static const ANIMATION_ID_NORMAL:int = 1;
        private static const _SafeStr_3357:int = 15;

        private var _stateQueue:Array = [];
        private var _animationCounter:int;

        override protected function setAnimation(_arg_1:int):void
        {
            if (_arg_1 == 2)
            {
                _stateQueue = [];
                _stateQueue.push(1);
                _animationCounter = 15;
            };

            super.setAnimation(_arg_1);
        }

        override protected function updateAnimation(_arg_1:Number):int
        {
            if (_animationCounter > 0)
            {
                _animationCounter--;
            };

            if (_animationCounter == 0)
            {
                if (_stateQueue.length > 0)
                {
                    super.setAnimation(_stateQueue.shift());
                };
            };

            return (super.updateAnimation(_arg_1));
        }

        override protected function usesAnimationResetting():Boolean
        {
            return (true);
        }

    }
}
