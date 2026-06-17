package com.sulake.room.object.visualization
{
    public /*dynamic*/ interface IRoomObjectSpriteVisualization extends IRoomObjectGraphicVisualization 
    {

        function get spriteCount():int;
        function getSprite(_index:int):IRoomObjectSprite;
        function getSpriteList():Array;

    }
}

