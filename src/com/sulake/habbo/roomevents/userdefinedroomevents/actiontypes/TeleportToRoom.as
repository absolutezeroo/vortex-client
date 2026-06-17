package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
{
    public class TeleportToRoom extends DefaultActionType
    {

        override public function get code():int
        {
            return (_SafeStr_226.TELEPORT_TO_ROOM);
        }

    }
}
