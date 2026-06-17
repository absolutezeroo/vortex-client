package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarPlayingGameMessage extends RoomObjectUpdateStateMessage 
    {

        private var _isPlayingGame:Boolean;

        public function RoomObjectAvatarPlayingGameMessage(isPlayingGame:Boolean=false)
        {
            _isPlayingGame = isPlayingGame;
        }

        public function get isPlayingGame():Boolean
        {
            return (_isPlayingGame);
        }

    }
}