package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import com.sulake.room.utils.XmlUtil;
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

            var floorsList:XMLList = data.floors;

            if (floorsList.length() > 0)
            {
                parseFloors(floorsList[0]);
            };
        }

        private function parseFloors(floorsXml:XML):void
        {
            var i:int;
            var floorXml:XML;
            var id:String;
            var visualizationList:XMLList;
            var floorPlane:FloorPlane;

            if (floorsXml == null)
            {
                return;
            };

            var floorList:XMLList = floorsXml.floor;
            i = 0;

            while (i < floorList.length())
            {
                floorXml = floorList[i];

                if (XmlUtil.checkRequiredAttributes(floorXml, ["id"]))
                {
                    id = floorXml.@id;
                    visualizationList = floorXml.visualization;
                    floorPlane = new FloorPlane();
                    parseVisualizations(floorPlane, visualizationList);

                    if (!addPlane(id, floorPlane))
                    {
                        floorPlane.dispose();
                    };
                };

                i++;
            };
        }

        override public function render(canvas:BitmapData, id:String, width:Number, height:Number, scale:Number, normal:IVector3d, useTexture:Boolean, offsetX:Number=0, offsetY:Number=0, maxX:Number=0, maxY:Number=0, timeSinceStartMs:int=0):PlaneBitmapData
        {
            var floorPlane:FloorPlane = (getPlane(id) as FloorPlane);

            if (floorPlane == null)
            {
                floorPlane = (getPlane("default") as FloorPlane);
            };

            if (floorPlane == null)
            {
                return (null);
            };

            if (canvas != null)
            {
                canvas.fillRect(canvas.rect, 0xFFFFFF);
            };

            var bitmapData:BitmapData = floorPlane.render(canvas, width, height, scale, normal, useTexture, offsetX, offsetY);

            if (((!(bitmapData == null)) && (!(bitmapData == canvas))))
            {
                try
                {
                    bitmapData = bitmapData.clone();
                }

                catch(e:Error)
                {
                    if (bitmapData)
                    {
                        bitmapData.dispose();
                    };

                    return (null);
                };
            };

            var planeBitmapData:PlaneBitmapData = new PlaneBitmapData(bitmapData, -1);
            return (planeBitmapData);
        }

    }
}

