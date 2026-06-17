package com.sulake.room.renderer {

    public /*dynamic*/interface IRoomRenderer extends IRoomRendererBase {

        function set roomObjectVariableAccurateZ(variableName:String):void;
        function createCanvas(canvasId:int, width:int, height:int, displayMode:int):IRoomRenderingCanvas;
        function getCanvas(canvasId:int):IRoomRenderingCanvas;
        function disposeCanvas(canvasId:int):Boolean;

    }
}
