package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import com.sulake.room.utils._SafeStr_93;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;
    import com.sulake.room.utils.IVector3d;

    public class FloorRasterizer extends PlaneRasterizer 
    {

        override protected function initializePlanes():void
        {
            if (data == null)
            {
                return;
            };

            var _local_1:XMLList = data.floors;

            if (_local_1.length() > 0)
            {
                parseFloors(_local_1[0]);
            };
        }

        private function parseFloors(_arg_1:XML):void
        {
            var _local_4:int;
            var _local_7:XML;
            var _local_5:String;
            var _local_3:XMLList;
            var _local_6:FloorPlane;

            if (_arg_1 == null)
            {
                return;
            };

            var _local_2:XMLList = _arg_1.floor;
            _local_4 = 0;

            while (_local_4 < _local_2.length())
            {
                _local_7 = _local_2[_local_4];

                if (_SafeStr_93.checkRequiredAttributes(_local_7, ["id"]))
                {
                    _local_5 = _local_7.@id;
                    _local_3 = _local_7.visualization;
                    _local_6 = new FloorPlane();
                    parseVisualizations(_local_6, _local_3);

                    if (!addPlane(_local_5, _local_6))
                    {
                        _local_6.dispose();
                    };
                };

                _local_4++;
            };
        }

        override public function render(canvas:BitmapData, id:String, width:Number, height:Number, scale:Number, normal:IVector3d, useTexture:Boolean, offsetX:Number=0, offsetY:Number=0, maxX:Number=0, maxY:Number=0, timeSinceStartMs:int=0):PlaneBitmapData
        {
            var _local_15:FloorPlane = (getPlane(id) as FloorPlane);

            if (_local_15 == null)
            {
                _local_15 = (getPlane("default") as FloorPlane);
            };

            if (_local_15 == null)
            {
                return (null);
            };

            if (canvas != null)
            {
                canvas.fillRect(canvas.rect, 0xFFFFFF);
            };

            var _local_14:BitmapData = _local_15.render(canvas, width, height, scale, normal, useTexture, offsetX, offsetY);

            if (((!(_local_14 == null)) && (!(_local_14 == canvas))))
            {
                try
                {
                    _local_14 = _local_14.clone();
                }

                catch(e:Error)
                {
                    if (_local_14)
                    {
                        _local_14.dispose();
                    };

                    return (null);
                };
            };

            var _local_13:PlaneBitmapData = new PlaneBitmapData(_local_14, -1);
            return (_local_13);
        }

    }
}
