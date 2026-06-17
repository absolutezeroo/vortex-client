package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.messages.RoomObjectGroupBadgeUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectSelectedMessage;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

    public class FurnitureAchievementResolutionLogic extends _SafeStr_111 
    {

        public static const STATE_RESOLUTION_NOT_STARTED:int = 0;
        public static const STATE_RESOLUTION_IN_PROGRESS:int = 1;
        public static const STATE_RESOLUTION_ACHIEVED:int = 2;
        public static const STATE_RESOLUTION_FAILED:int = 3;
        private static const ACH_NOT_SET:String = "ACH_0";
        private static const BADGE_VISIBLE_IN_STATE:Number = 2;

        override public function getEventTypes():Array
        {
            var _eventTypes:Array = ["ROWRE_ACHIEVEMENT_RESOLUTION_OPEN", "ROWRE_ACHIEVEMENT_RESOLUTION_ENGRAVING", "ROWRE_ACHIEVEMENT_RESOLUTION_FAILED", "ROGBE_LOAD_BADGE"];
            return (getAllEventTypes(super.getEventTypes(), _eventTypes));
        }

        override public function processUpdateMessage(_message:RoomObjectUpdateMessage):void
        {
            var _closeMenuEvent:RoomObjectEvent;
            super.processUpdateMessage(_message);

            var _badgeUpdateMessage:RoomObjectGroupBadgeUpdateMessage = (_message as RoomObjectGroupBadgeUpdateMessage);

            if (_badgeUpdateMessage != null)
            {
                if (_badgeUpdateMessage.assetName != "loading_icon")
                {
                    object.getModelController().setNumber("furniture_badge_visible_in_state", 2);
                };
            };

            var _selectedMessage:RoomObjectSelectedMessage = (_message as RoomObjectSelectedMessage);

            if (_selectedMessage)
            {
                if (((!(eventDispatcher == null)) && (!(object == null))))
                {
                    if (!_selectedMessage.selected)
                    {
                        _closeMenuEvent = new RoomObjectWidgetRequestEvent("ROWRE_CLOSE_FURNI_CONTEXT_MENU", object);
                        eventDispatcher.dispatchEvent(_closeMenuEvent);
                    };
                };
            };
        }

        override public function useObject():void
        {
            var _widgetRequestEvent:RoomObjectEvent;

            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                _widgetRequestEvent = null;
                switch (object.getState(0))
                {
                    case 0:
                    case 1:
                        _widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_ACHIEVEMENT_RESOLUTION_OPEN", object);
                        break;
                    case 2:
                        _widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_ACHIEVEMENT_RESOLUTION_ENGRAVING", object);
                        break;
                    case 3:
                        _widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_ACHIEVEMENT_RESOLUTION_FAILED", object);
                    default:
                };

                if (_widgetRequestEvent)
                {
                    eventDispatcher.dispatchEvent(_widgetRequestEvent);
                };
            };
        }

        override protected function updateBadge(_badgeCode:String):void
        {
            if (_badgeCode != "ACH_0")
            {
                super.updateBadge(_badgeCode);
            };
        }

    }
}
