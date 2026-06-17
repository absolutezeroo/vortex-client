package com.sulake.room.object.visualization
{
    import flash.display.BitmapData;

    public /*dynamic*/ interface IRoomObjectSprite 
    {

        function get asset():BitmapData;
        function set asset(_assetData:BitmapData):void;
        function get assetName():String;
        function set assetName(_assetName:String):void;
        function get libraryAssetName():String;
        function set libraryAssetName(_libraryAssetName:String):void;
        function get assetPosture():String;
        function set assetPosture(_assetPosture:String):void;
        function get visible():Boolean;
        function set visible(_isVisible:Boolean):void;
        function get tag():String;
        function set tag(_tag:String):void;
        function get alpha():int;
        function set alpha(_alpha:int):void;
        function get color():int;
        function set color(_color:int):void;
        function get blendMode():String;
        function set blendMode(_blendModeValue:String):void;
        function get filters():Array;
        function set filters(_filtersValue:Array):void;
        function get flipH():Boolean;
        function set flipH(_flipH:Boolean):void;
        function get flipV():Boolean;
        function set flipV(_flipV:Boolean):void;
        function get direction():int;
        function set direction(_direction:int):void;
        function get offsetX():int;
        function set offsetX(_offsetX:int):void;
        function get offsetY():int;
        function set offsetY(_offsetY:int):void;
        function get width():int;
        function get height():int;
        function get relativeDepth():Number;
        function set relativeDepth(_depth:Number):void;
        function get varyingDepth():Boolean;
        function set varyingDepth(_isVaryingDepth:Boolean):void;
        function get clickHandling():Boolean;
        function set clickHandling(_canClick:Boolean):void;
        function get instanceId():int;
        function get updateId():int;
        function set spriteType(_spriteType:int):void;
        function get spriteType():int;
        function set objectType(_objectType:String):void;
        function get objectType():String;
        function get alphaTolerance():int;
        function set alphaTolerance(_tolerance:int):void;
        function get planeId():int;
        function set planeId(_planeId:int):void;

    }
}

