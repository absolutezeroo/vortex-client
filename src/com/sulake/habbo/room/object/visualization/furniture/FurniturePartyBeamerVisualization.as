package com.sulake.habbo.room.object.visualization.furniture
{
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.geom.Point;

    public class FurniturePartyBeamerVisualization extends AnimatedFurnitureVisualization 
    {

        private static const UPDATE_INTERVAL:int = 2;
        private static const AREA_DIAMETER_SMALL:int = 15;
        private static const AREA_DIAMETER_LARGE:int = 31;
        private static const ANIM_SPEED_FAST:int = 2;
        private static const _SafeStr_3334:int = 1;

        private var _animPhaseIndex:Array;
        private var _animDirectionIndex:Array;
        private var _animSpeedIndex:Array;
        private var _animFactorIndex:Array;
        private var _animOffsetIndex:Array = [];

        override protected function updateAnimation(_arg_1:Number):int
        {
            var _local_3:IRoomObjectSprite;

            if (_animSpeedIndex == null)
            {
                initItems(_arg_1);
            };

            _local_3 = getSprite(2);

            if (_local_3 != null)
            {
                _animOffsetIndex[0] = getNewPoint(_arg_1, 0);
            };

            _local_3 = getSprite(3);

            if (_local_3 != null)
            {
                _animOffsetIndex[1] = getNewPoint(_arg_1, 1);
            };

            return (super.updateAnimation(_arg_1));
        }

        override protected function getSpriteXOffset(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            if (((_arg_3 == 2) || (_arg_3 == 3)))
            {
                if (_animOffsetIndex.length == 2)
                {
                    return (_animOffsetIndex[(_arg_3 - 2)].x);
                };
            };

            return (super.getSpriteXOffset(_arg_1, _arg_2, _arg_3));
        }

        override protected function getSpriteYOffset(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            if (((_arg_3 == 2) || (_arg_3 == 3)))
            {
                if (_animOffsetIndex.length == 2)
                {
                    return (_animOffsetIndex[(_arg_3 - 2)].y);
                };
            };

            return (super.getSpriteYOffset(_arg_1, _arg_2, _arg_3));
        }

        private function getNewPoint(_arg_1:Number, _arg_2:int):Point
        {
            var _local_8:int;
            var _local_10:Number = _animPhaseIndex[_arg_2];
            var _local_3:int = _animDirectionIndex[_arg_2];
            var _local_5:int = _animSpeedIndex[_arg_2];
            var _local_6:Number = _animFactorIndex[_arg_2];
            var _local_11:Number = 1;

            if (_arg_1 == 32)
            {
                _local_8 = 15;
                _local_11 = 0.5;
            }

            else
            {
                _local_8 = 31;
            };

            var _local_7:Number = (_local_10 + (_local_3 * _local_5));

            if (Math.abs(_local_7) >= _local_8)
            {
                if (_local_3 > 0)
                {
                    _local_10 = (_local_10 - (_local_7 - _local_8));
                }

                else
                {
                    _local_10 = (_local_10 + (-(_local_8) - _local_7));
                };

                _local_3 = -(_local_3);
                _animDirectionIndex[_arg_2] = _local_3;
            };

            var _local_4:Number = ((_local_8 - Math.abs(_local_10)) * _local_6);
            var _local_9:Number = ((_local_3 * Math.sin(Math.abs((_local_10 / 4)))) * _local_4);

            if (_local_3 > 0)
            {
                _local_9 = (_local_9 - _local_4);
            }

            else
            {
                _local_9 = (_local_9 + _local_4);
            };

            _local_10 = (_local_10 + ((_local_3 * _local_5) * _local_11));
            _animPhaseIndex[_arg_2] = _local_10;

            if (_local_9 == 0)
            {
                _animFactorIndex[_arg_2] = getRandomAmplitudeFactor();
            };

            return (new Point(_local_10, _local_9));
        }

        private function initItems(_arg_1:Number):void
        {
            var _local_2:int;

            if (_arg_1 == 32)
            {
                _local_2 = 15;
            }

            else
            {
                _local_2 = 31;
            };

            _animPhaseIndex = [];
            _animPhaseIndex.push(((Math.random() * _local_2) * 1.5));
            _animPhaseIndex.push(((Math.random() * _local_2) * 1.5));
            _animDirectionIndex = [];
            _animDirectionIndex.push(1);
            _animDirectionIndex.push(-1);
            _animSpeedIndex = [];
            _animSpeedIndex.push(2);
            _animSpeedIndex.push(1);
            _animFactorIndex = [];
            _animFactorIndex.push(getRandomAmplitudeFactor());
            _animFactorIndex.push(getRandomAmplitudeFactor());
        }

        private function getRandomAmplitudeFactor():Number
        {
            return (((Math.random() * 30) / 100) + 0.15);
        }

    }
}
