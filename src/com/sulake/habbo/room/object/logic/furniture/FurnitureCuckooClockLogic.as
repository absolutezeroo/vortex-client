package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.events.RoomObjectPlaySoundIdEvent;

    public class FurnitureCuckooClockLogic extends FurnitureMultiStateLogic 
    {

        private var _state:int = -1;
        private var _loc:IVector3d;

        override public function getEventTypes():Array
        {
            var _eventTypes:Array = ["ROPSIE_PLAY_SOUND_AT_PITCH"];
            return (getAllEventTypes(super.getEventTypes(), _eventTypes));
        }

        override public function processUpdateMessage(_message:RoomObjectUpdateMessage):void
        {
            super.processUpdateMessage(_message);

            var _dataUpdateMessage:RoomObjectDataUpdateMessage = (_message as RoomObjectDataUpdateMessage);

            if (_dataUpdateMessage != null)
            {
                if (((!(_state == -1)) && (!(_dataUpdateMessage.state == _state))))
                {
                    playSoundAt(_loc.z);
                };

                _state = _dataUpdateMessage.state;
            }

            else
            {
                _loc = _message.loc;
            };
        }

        private function playSoundAt(_pitchHeight:Number):void
        {
            var _pitch:Number = Math.pow(2, (_pitchHeight - 1.2));
            eventDispatcher.dispatchEvent(new RoomObjectPlaySoundIdEvent("ROPSIE_PLAY_SOUND_AT_PITCH", object, "FURNITURE_cuckoo_clock", _pitch));
        }

    }
}
