package com.sulake.habbo.room.object.visualization.data
{
    public class AnimationFrameDirectionalData extends AnimationFrameData 
    {

        private var _directionalOffsets:DirectionalOffsetData;

        public function AnimationFrameDirectionalData(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:DirectionalOffsetData, _arg_7:int)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_7);
            _directionalOffsets = _arg_6;
        }

        override public function hasDirectionalOffsets():Boolean
        {
            return (!(_directionalOffsets == null));
        }

        override public function getX(_arg_1:int):int
        {
            if (_directionalOffsets != null)
            {
                return (_directionalOffsets.getOffsetX(_arg_1, super.getX(_arg_1)));
            };

            return (super.getX(_arg_1));
        }

        override public function getY(_arg_1:int):int
        {
            if (_directionalOffsets != null)
            {
                return (_directionalOffsets.getOffsetY(_arg_1, super.getY(_arg_1)));
            };

            return (super.getY(_arg_1));
        }

    }
}
