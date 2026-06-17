package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import com.sulake.room.utils.Vector3d;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import com.sulake.room.utils.IVector3d;

    public class FloorPlane extends Plane 
    {

        public static const DEFAULT_COLOR:uint = 0xFFFFFF;
        public static const HORIZONTAL_ANGLE_DEFAULT:Number = 45;
        public static const VERTICAL_ANGLE_DEFAULT:Number = 30;

        public function render(canvas:BitmapData, width:Number, height:Number, size:Number, normal:IVector3d, useTexture:Boolean, offsetX:Number, offsetY:Number):BitmapData
        {
            var unitPixelLength:Number;
            var planeVisualization:PlaneVisualization = getPlaneVisualization(size);

            if (((planeVisualization == null) || (planeVisualization.geometry == null)))
            {
                return (null);
            };

            var originPoint:Point = planeVisualization.geometry.getScreenPoint(new Vector3d(0, 0, 0));
            var heightPoint:Point = planeVisualization.geometry.getScreenPoint(new Vector3d(0, (height / planeVisualization.geometry.scale), 0));
            var widthPoint:Point = planeVisualization.geometry.getScreenPoint(new Vector3d((width / planeVisualization.geometry.scale), 0, 0));
            var pixelOffsetX:int;
            var pixelOffsetY:int;

            if ((((!(originPoint == null)) && (!(heightPoint == null))) && (!(widthPoint == null))))
            {
                width = Math.round(Math.abs((originPoint.x - widthPoint.x)));
                height = Math.round(Math.abs((originPoint.x - heightPoint.x)));
                unitPixelLength = (originPoint.x - planeVisualization.geometry.getScreenPoint(new Vector3d(1, 0, 0)).x);
                pixelOffsetX = (offsetX * Math.abs(unitPixelLength));
                pixelOffsetY = (offsetY * Math.abs(unitPixelLength));
            };

            return (planeVisualization.render(canvas, width, height, normal, useTexture, pixelOffsetX, pixelOffsetY));
        }

    }
}