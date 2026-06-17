package com.sulake.habbo.room
{
    import flash.display.BitmapData;

    public /*dynamic*/ interface IGetImageListener 
    {

        function imageReady(requestId:int, imageData:BitmapData):void;
        function imageFailed(requestId:int):void;

    }
}