package com.sulake.habbo.room.object.visualization.room.rasterizer.animated
{
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.Plane;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneVisualization;
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;

    public class LandscapePlane extends Plane 
    {

        public static const DEFAULT_COLOR:uint = 0xFFFFFF;
        public static const HORIZONTAL_ANGLE_DEFAULT:Number = 45;
        public static const VERTICAL_ANGLE_DEFAULT:Number = 30;

        private var _width:int = 0;
        private var _height:int = 0;

        override public function isStatic(scale:int):Boolean
        {
            var planeVisualization:PlaneVisualization = getPlaneVisualization(scale);

            if (planeVisualization != null)
            {
                return (!(planeVisualization.hasAnimationLayers));
            };

            return (super.isStatic(scale));
        }

        public function initializeDimensions(width:int, height:int):void
        {
            if (width < 0)
            {
                width = 0;
            };

            if (height < 0)
            {
                height = 0;
            };

            if (((!(width == _width)) || (!(height == _height))))
            {
                _width = width;
                _height = height;
            };
        }

        public function render(canvas:BitmapData, width:Number, height:Number, scale:Number, normal:IVector3d, useTexture:Boolean, offsetX:Number, offsetY:Number, maxX:Number, maxY:Number, timeSinceStartMs:int):BitmapData
        {
            var offsetPixelX:int;
            var maxPixelY:int;
            var maxPixelX:int;
            var offsetPixelY:int;
            var resultBitmapData:BitmapData;
            var planeVisualization:PlaneVisualization = getPlaneVisualization(scale);

            if (((planeVisualization == null) || (planeVisualization.geometry == null)))
            {
                return (null);
            };

            var originPoint:Point = planeVisualization.geometry.getScreenPoint(new Vector3d(0, 0, 0));
            var depthPoint:Point = planeVisualization.geometry.getScreenPoint(new Vector3d(0, 0, 1));
            var widthPoint:Point = planeVisualization.geometry.getScreenPoint(new Vector3d(0, 1, 0));

            if ((((!(originPoint == null)) && (!(depthPoint == null))) && (!(widthPoint == null))))
            {
                width = Math.round(Math.abs((((originPoint.x - widthPoint.x) * width) / planeVisualization.geometry.scale)));
                height = Math.round(Math.abs((((originPoint.y - depthPoint.y) * height) / planeVisualization.geometry.scale)));
                offsetPixelX = (offsetX * Math.abs((originPoint.x - widthPoint.x)));
                offsetPixelY = (offsetY * Math.abs((originPoint.y - depthPoint.y)));
                maxPixelX = (maxX * Math.abs((originPoint.x - widthPoint.x)));
                maxPixelY = (maxY * Math.abs((originPoint.y - depthPoint.y)));
                resultBitmapData = planeVisualization.render(canvas, width, height, normal, useTexture, offsetPixelX, offsetPixelY, maxPixelX, maxPixelY, maxX, maxY, timeSinceStartMs);
                return (resultBitmapData);
            };

            return (null);
        }

    }
}
