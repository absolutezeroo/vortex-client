package com.sulake.habbo.room
{
    import com.sulake.room.IRoomInstance;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.habbo.room.utils.FurniStackingHeightMap;
    import com.sulake.habbo.room.utils.LegacyWallGeometry;
    import com.sulake.habbo.room.utils.TileObjectMap;
    import com.sulake.core.runtime.ICoreConfiguration;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.session.ISessionDataManager;

        public /*dynamic*/ interface IRoomCreator extends IRoomObjectCreator 
    {

        function initializeRoom(roomId:int, roomData:XML):void;
        function getRoom(roomId:int):IRoomInstance;
        function disposeRoom(roomId:int):void;
        function setOwnUserId(roomId:int, ownUserRoomId:int):void;
        function setWorldType(roomId:int, worldType:String):void;
        function getObjectRoom(roomId:int):IRoomObjectController;
        function setFurniStackingHeightMap(roomId:int, furniStackingHeightMap:FurniStackingHeightMap):void;
        function getFurniStackingHeightMap(roomId:int):FurniStackingHeightMap;
        function getLegacyGeometry(roomId:int):LegacyWallGeometry;
        function getTileObjectMap(roomId:int):TileObjectMap;
        function getRoomNumberValue(roomId:int, key:String):Number;
        function getRoomStringValue(roomId:int, key:String):String;
        function setIsPlayingGame(roomId:int, isPlayingGame:Boolean):void;
        function refreshTileObjectMap(roomId:int, category:String):void;
        function get configuration():ICoreConfiguration;
        function get roomSessionManager():IRoomSessionManager;
        function get sessionDataManager():ISessionDataManager;

    }
}