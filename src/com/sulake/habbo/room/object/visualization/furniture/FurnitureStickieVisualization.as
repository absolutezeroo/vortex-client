package com.sulake.habbo.room.object.visualization.furniture
{
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;

    public class FurnitureStickieVisualization extends FurnitureVisualization 
    {

        private var _data:FurnitureVisualizationData = null;

        override public function initialize(_arg_1:IRoomObjectVisualizationData):Boolean
        {
            _data = (_arg_1 as FurnitureVisualizationData);
            return (super.initialize(_arg_1));
        }

        override protected function getSpriteColor(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            if (_data == null)
            {
                return (0xFFFFFF);
            };

            var _local_4:int = _data.getColor(_arg_1, _arg_2, _arg_3);
            return (_local_4);
        }

    }
}
