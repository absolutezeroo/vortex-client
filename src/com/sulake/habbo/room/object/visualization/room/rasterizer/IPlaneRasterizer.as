package com.sulake.habbo.room.object.visualization.room.rasterizer
{
    import flash.display.BitmapData;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;

    public /*dynamic*/ interface IPlaneRasterizer 
    {

        function initializeDimensions(width:int, height:int):Boolean;
        function render(canvas:BitmapData, id:String, width:Number, height:Number, scale:Number, normal:IVector3d, useTexture:Boolean, offsetX:Number=0, offsetY:Number=0, maxX:Number=0, maxY:Number=0, timeSinceStartMs:int=0):PlaneBitmapData;
        function getTextureIdentifier(scale:Number, normal:IVector3d):String;
        function getLayers(id:String):Array;
        function reinitialize():void;

    }
}