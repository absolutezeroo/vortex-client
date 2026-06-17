package com.sulake.room.exceptions
{
    public class RoomManagerException extends Error 
    {

        public function RoomManagerException(message:String="", id:int=0)
        {
            super(message, id);
        }

    }
}
