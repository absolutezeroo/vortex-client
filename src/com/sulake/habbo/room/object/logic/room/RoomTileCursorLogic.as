package com.sulake.habbo.room.object.logic.room
{
    import com.sulake.room.object.logic.ObjectLogicBase;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.messages.RoomObjectTileCursorUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

    public class RoomTileCursorLogic extends ObjectLogicBase 
    {

        private static const STATE_ENABLED:int = 0;
        private static const STATE_DISABLED:int = 1;
        private static const STATE_SHOW_TILE_HEIGHT:int = 6;

        private var _SafeStr_3213:String;
        private var _hiddenOnPurpose:Boolean;

        override public function initialize(data:XML):void
        {
            var modelController:IRoomObjectModelController;

            if (object != null)
            {
                modelController = object.getModelController();

                if (modelController != null)
                {
                    modelController.setNumber("furniture_alpha_multiplier", 1);
                    object.setState(1, 0);
                };
            };
        }

        override public function processUpdateMessage(message:RoomObjectUpdateMessage):void
        {
            var height:Number;
            var state:int;
            var tileCursorMessage:RoomObjectTileCursorUpdateMessage = (message as RoomObjectTileCursorUpdateMessage);

            if (tileCursorMessage == null)
            {
                return;
            };

            if (((!(_SafeStr_3213 == null)) && (_SafeStr_3213 == tileCursorMessage.sourceEventId)))
            {
                return;
            };

            if (tileCursorMessage.toggleVisibility)
            {
                _hiddenOnPurpose = (!(_hiddenOnPurpose));
            };

            super.processUpdateMessage(message);

            if (object != null)
            {
                if (_hiddenOnPurpose)
                {
                    object.setState(1, 0);
                }

                else
                {
                    if (!tileCursorMessage.visible)
                    {
                        object.setState(1, 0);
                    }

                    else
                    {
                        height = tileCursorMessage.height;
                        object.getModelController().setNumber("tile_cursor_height", height);
                        state = ((height > 0.8) ? 6 : 0);
                        object.setState(state, 0);
                    };
                };
            };

            _SafeStr_3213 = tileCursorMessage.sourceEventId;
        }

    }
}
