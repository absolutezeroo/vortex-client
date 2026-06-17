package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectGroupBadgeUpdateMessage;
    import flash.utils.getTimer;
    import com.sulake.habbo.room.messages.RoomObjectSelectedMessage;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.habbo.room.events.RoomObjectBadgeAssetEvent;

    public class FurnitureGuildCustomizedLogic extends FurnitureMultiStateLogic 
    {

        public static const GUILD_ID_STUFFDATA_KEY:int = 1;
        public static const BADGE_CODE_STUFFDATA_KEY:int = 2;
        public static const COLOR_1_STUFFDATA_KEY:int = 3;
        public static const COLOR_2_STUFFDATA_KEY:int = 4;

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROGBE_LOAD_BADGE", "ROWRE_GUILD_FURNI_CONTEXT_MENU", "ROWRE_CLOSE_FURNI_CONTEXT_MENU"];
            return (getAllEventTypes(super.getEventTypes(), eventTypes));
        }

        override public function processUpdateMessage(_arg_updateMessage:RoomObjectUpdateMessage):void
        {
            var stringArrayStuffData:StringArrayStuffData;
            var closeContextMenuEvent:RoomObjectEvent;
            super.processUpdateMessage(_arg_updateMessage);

            var dataUpdateMessage:RoomObjectDataUpdateMessage = (_arg_updateMessage as RoomObjectDataUpdateMessage);

            if (dataUpdateMessage != null)
            {
                stringArrayStuffData = (dataUpdateMessage.data as StringArrayStuffData);

                if (stringArrayStuffData != null)
                {
                    updateGuildId(stringArrayStuffData.getValue(1));
                    updateGuildBadge(stringArrayStuffData.getValue(2));
                    updateGuildColors(stringArrayStuffData.getValue(3), stringArrayStuffData.getValue(4));
                };
            };

            var groupBadgeUpdateMessage:RoomObjectGroupBadgeUpdateMessage = (_arg_updateMessage as RoomObjectGroupBadgeUpdateMessage);

            if (groupBadgeUpdateMessage != null)
            {
                if (groupBadgeUpdateMessage.assetName != "loading_icon")
                {
                    object.getModelController().setString("furniture_guild_customized_asset_name", groupBadgeUpdateMessage.assetName);
                    this.update(getTimer());
                };
            };

            var selectedMessage:RoomObjectSelectedMessage = (_arg_updateMessage as RoomObjectSelectedMessage);

            if (selectedMessage)
            {
                if (((!(eventDispatcher == null)) && (!(object == null))))
                {
                    if (!selectedMessage.selected)
                    {
                        closeContextMenuEvent = new RoomObjectWidgetRequestEvent("ROWRE_CLOSE_FURNI_CONTEXT_MENU", object);
                        eventDispatcher.dispatchEvent(closeContextMenuEvent);
                    };
                };
            };
        }

        override public function mouseEvent(_arg_mouseEvent:RoomSpriteMouseEvent, _arg_geometry:IRoomGeometry):void
        {
            if (((_arg_mouseEvent == null) || (_arg_geometry == null)))
            {
                return;
            };

            if (object == null)
            {
                return;
            };

            switch (_arg_mouseEvent.type)
            {
                case "click":
                    openContextMenu();
                default:
                    super.mouseEvent(_arg_mouseEvent, _arg_geometry);
                    return;
            };
        }

        protected function openContextMenu():void
        {
            var contextMenuEvent:RoomObjectEvent = new RoomObjectWidgetRequestEvent("ROWRE_GUILD_FURNI_CONTEXT_MENU", object);
            eventDispatcher.dispatchEvent(contextMenuEvent);
        }

        private function updateGuildColors(_arg_color1:String, _arg_color2:String):void
        {
            object.getModelController().setNumber("furniture_guild_customized_color_1", parseInt(_arg_color1, 16));
            object.getModelController().setNumber("furniture_guild_customized_color_2", parseInt(_arg_color2, 16));
        }

        private function updateGuildBadge(_arg_badgeCode:String):void
        {
            eventDispatcher.dispatchEvent(new RoomObjectBadgeAssetEvent("ROGBE_LOAD_BADGE", object, _arg_badgeCode, true));
        }

        protected function updateGuildId(_arg_guildId:String):void
        {
            object.getModelController().setNumber("furniture_guild_customized_guild_id", parseInt(_arg_guildId));
        }

    }
}