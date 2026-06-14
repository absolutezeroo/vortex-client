package com.sulake.habbo.freeflowchat.data
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.session.events.RoomSessionEvent;

    public class RoomSessionEventHandler implements IDisposable 
    {

        private var _component:HabboFreeFlowChat;

        public function RoomSessionEventHandler(_arg_1:HabboFreeFlowChat)
        {
            _component = _arg_1;
            _component.roomSessionManager.events.addEventListener("RSE_CREATED", onRoomSessionCreated);
            _component.roomSessionManager.events.addEventListener("RSE_ENDED", onRoomSessionEnded);
        }

        public function dispose():void
        {
            if (!disposed)
            {
                if (_component)
                {
                    _component.roomSessionManager.events.removeEventListener("RSE_CREATED", onRoomSessionCreated);
                    _component.roomSessionManager.events.removeEventListener("RSE_ENDED", onRoomSessionEnded);
                    _component = null;
                };
            };
        }

        public function get disposed():Boolean
        {
            return (_component == null);
        }

        private function onRoomSessionCreated(_arg_1:RoomSessionEvent):void
        {
            _component.roomEntered();
        }

        private function onRoomSessionEnded(_arg_1:RoomSessionEvent):void
        {
            _component.roomLeft();
        }

    }
}
