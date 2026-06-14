package com.sulake.habbo.session.events
{
    import com.sulake.habbo.session.IRoomSession;

    public class RoomSessionPetCommandsUpdateEvent extends RoomSessionEvent 
    {

        public static const PET_COMMANDS:String = "RSPIUE_ENABLED_PET_COMMANDS";

        private var _petId:int;
        private var _allCommands:Array;
        private var _enabledCommands:Array;

        public function RoomSessionPetCommandsUpdateEvent(_arg_1:IRoomSession, id:int, commands:Array, enabledCommands:Array, _arg_5:Boolean=false, _arg_6:Boolean=false)
        {
            super("RSPIUE_ENABLED_PET_COMMANDS", _arg_1, _arg_5, _arg_6);
            _petId = id;
            _allCommands = commands;
            _enabledCommands = enabledCommands;
        }

        public function get petId():int
        {
            return (_petId);
        }

        public function get allCommands():Array
        {
            return (_allCommands);
        }

        public function get enabledCommands():Array
        {
            return (_enabledCommands);
        }

    }
}