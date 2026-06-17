package com.sulake.room.object.visualization
{
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    public /*dynamic*/ interface IRoomObjectVisualization 
    {

        function set object(_roomObject:IRoomObject):void;
        function get object():IRoomObject;
        function dispose():void;
        function initialize(_data:IRoomObjectVisualizationData):Boolean;
        function update(_geometry:IRoomGeometry, _timeSinceLastUpdate:int, _skipUpdates:Boolean, _skipAnimation:Boolean):void;
        function get image():BitmapData;
        function getImage(_width:int, _height:int):BitmapData;
        function get boundingRectangle():Rectangle;
        function getInstanceId():int;
        function getUpdateID():int;

    }
}

