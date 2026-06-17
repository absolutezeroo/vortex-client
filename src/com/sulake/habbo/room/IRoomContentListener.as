package com.sulake.habbo.room
{
        public /*dynamic*/ interface IRoomContentListener 
    {

        function iconLoaded(typeId:int, url:String, isFurnitureIcon:Boolean):void;

    }
}