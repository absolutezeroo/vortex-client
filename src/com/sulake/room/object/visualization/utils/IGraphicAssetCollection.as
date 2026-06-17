package com.sulake.room.object.visualization.utils
{
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;

    public /*dynamic*/ interface IGraphicAssetCollection
    {

        function dispose():void;
        function set assetLibrary(assetLibrary:IAssetLibrary):void;
        function addReference():void;
        function removeReference():void;
        function getReferenceCount():int;
        function getLastReferenceTimeStamp():int;
        function define(data:XML):Boolean;
        function getAsset(assetName:String):IGraphicAsset;
        function getAssetWithPalette(assetName:String, paletteId:String):IGraphicAsset;
        function getPaletteNames():Array;
        function getPaletteColors(paletteId:String):Array;
        function getPaletteXML(paletteId:String):XML;
        function addAsset(assetName:String, bitmap:BitmapData, overwrite:Boolean, xOffset:int=0, yOffset:int=0, flipH:Boolean=false, flipV:Boolean=false):Boolean;
        function disposeAsset(assetName:String):void;

    }
}
