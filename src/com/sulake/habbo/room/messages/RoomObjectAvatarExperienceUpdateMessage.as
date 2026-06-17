package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarExperienceUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _gainedExperience:int;

        public function RoomObjectAvatarExperienceUpdateMessage(gainedExperience:int)
        {
            _gainedExperience = gainedExperience;
        }

        public function get gainedExperience():int
        {
            return (_gainedExperience);
        }

    }
}