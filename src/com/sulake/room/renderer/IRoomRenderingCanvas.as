package com.sulake.room.renderer {
    import flash.display.DisplayObject;
    import com.sulake.room.utils.IRoomGeometry;
    import __AS3__.vec.Vector;
    import com.sulake.room.data.RoomObjectSpriteData;
    import flash.geom.Point;
    import flash.display.BitmapData;

    public /*dynamic*/interface IRoomRenderingCanvas {

        function set useMask(useMask:Boolean):void;
        function initialize(width:int, height:int):void;
        function get width():int;
        function get height():int;
        function set screenOffsetX(screenOffsetX:int):void;
        function set screenOffsetY(screenOffsetY:int):void;
        function get screenOffsetX():int;
        function get screenOffsetY():int;
        function render(timestamp:int, forceRedraw:Boolean = false):void;
        function get displayObject():DisplayObject;
        function get geometry():IRoomGeometry;
        function set mouseListener(mouseListener:IRoomRenderingCanvasMouseListener):void;
        function handleMouseEvent(mouseX:int, mouseY:int, eventType:String, ctrlKey:Boolean, shiftKey:Boolean, altKey:Boolean, isRightClick:Boolean):Boolean;
        function getSortableSpriteList():Vector.<RoomObjectSpriteData>;
        function getPlaneSortableSprites():Array;
        function setScale(scale:Number, registrationPoint:Point = null, offsetPoint:Point = null, instant:Boolean = false):void;
        function get scale():Number;
        function takeScreenShot():BitmapData;
        function skipSpriteVisibilityChecking():void;
        function resumeSpriteVisibilityChecking():void;
        function getId():int;

    }
}
