package com.sulake.habbo.help.cfh.registry.chat
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.HabboHelp;
    import com.sulake.habbo.session.IUserData;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;

    public class ChatEventHandler implements IDisposable 
    {

        private var _component:HabboHelp;

        public function ChatEventHandler(_arg_1:HabboHelp)
        {
            _component = _arg_1;
            _component.roomSessionManager.events.addEventListener("RSCE_CHAT_EVENT", onRoomChat);
        }

        public function dispose():void
        {
            if (!disposed)
            {
                if (_component)
                {
                    _component.roomSessionManager.events.removeEventListener("RSCE_CHAT_EVENT", onRoomChat);
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
            var _local_2:IUserData = _component.roomSessionManager.getSession(_arg_1.session.roomId).userDataManager.getUserDataByIndex(_arg_1.userId);
            var _local_3:GuestRoomData = _component.navigator.enteredGuestRoomData;

            if ((((!(_local_2)) || (!(_local_2.type == 1))) || (!(_local_3))))
            {
                return;
            };

            var _local_4:String = ((_local_3) ? _local_3.roomName : "Unknown Room");
            _component.chatRegistry.addItem(_arg_1.session.roomId, _local_4, _local_2.webID, _local_2.name, _arg_1.text);
        }

    }
}
