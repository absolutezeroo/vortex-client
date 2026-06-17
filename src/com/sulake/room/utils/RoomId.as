package com.sulake.room.utils
{
    public class RoomId 
    {

        private static const PREVIEW_ROOM_ID_BASE:int = 0x7FFF0000;

        public static function makeRoomPreviewerId(roomId:int):int
        {
            return ((roomId & 0xFFFF) + 0x7FFF0000);
        }

        public static function isRoomPreviewerId(roomId:int):Boolean
        {
            return (roomId >= 0x7FFF0000);
        }

    }
}
