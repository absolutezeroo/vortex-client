package com.sulake.habbo.freeflowchat.data
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.IVector3d;
    import flash.utils.getTimer;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import com.sulake.habbo.game.events.GameChatEvent;

    public class ChatEventHandler implements IDisposable 
    {

        public static const CHAT_STYLE_SNOWWAR_RED:int = 120;
        public static const CHAT_STYLE_SNOWWAR_BLUE:int = 121;

        private var _component:HabboFreeFlowChat;
        private var _lastAddedChatMs:uint = 0;
        private var _chatFakeMsIncrementor:uint = 0;

        public function ChatEventHandler(_arg_1:HabboFreeFlowChat)
        {
            _component = _arg_1;
            _component.roomSessionManager.events.addEventListener("RSCE_CHAT_EVENT", onRoomChat);

            if (_component.gameManager)
            {
                _component.gameManager.events.addEventListener("gce_game_chat", gameEventHandler);
            };
        }

        public function dispose():void
        {
            if (!disposed)
            {
                if (_component)
                {
                    _component.roomSessionManager.events.removeEventListener("RSCE_CHAT_EVENT", onRoomChat);
                    _component.gameManager.events.removeEventListener("gce_game_chat", gameEventHandler);
                    _component = null;
                };
            };
        }

        public function get disposed():Boolean
        {
            return (_component == null);
        }

        private function onRoomChat(_arg_1:RoomSessionChatEvent):void
        {
            var _local_3:IRoomObject = _component.roomEngine.getRoomObject(_arg_1.session.roomId, _arg_1.userId, 100);
            var _local_4:IVector3d;

            if (_local_3 != null)
            {
                _local_4 = _local_3.getLocation();
            };

            var _local_2:uint = getTimer();

            if (_local_2 == _lastAddedChatMs)
            {
                _chatFakeMsIncrementor++;
            }

            else
            {
                _chatFakeMsIncrementor = 0;
            };

            _component.insertChat(new ChatItem(_arg_1, (_local_2 + _chatFakeMsIncrementor), _local_4, _arg_1.extraParam));
            _lastAddedChatMs = _local_2;
        }

        private function gameEventHandler(_arg_1:GameChatEvent):void
        {
            var _local_3:int = ((_arg_1.teamId == 1) ? 121 : 120);
            var _local_2:RoomSessionChatEvent = new RoomSessionChatEvent("RSCE_CHAT_EVENT", null, _arg_1.userId, _arg_1.message, 0, _local_3);
            _component.insertChat(new ChatItem(_local_2, getTimer(), null, 0, _arg_1.locX, _arg_1.color, _arg_1.figure, _arg_1.name));
        }

    }
}
