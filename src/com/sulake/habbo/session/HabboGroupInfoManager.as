package com.sulake.habbo.session
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupBadgesMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupBadgesMessageComposer;

    public class HabboGroupInfoManager implements IDisposable 
    {

        private var _sessionDataManager:SessionDataManager;
        private var _badges:Map;
        private var _roomReadyMessageEvent:IMessageEvent;
        private var _habboGroupBadgesMessageEvent:IMessageEvent;

        public function HabboGroupInfoManager(_arg_1:SessionDataManager)
        {
            _sessionDataManager = _arg_1;
            _badges = new Map();

            if (_sessionDataManager.communication)
            {
                _roomReadyMessageEvent = _sessionDataManager.communication.addHabboConnectionMessageEvent(new RoomReadyMessageEvent(onRoomReady));
                _habboGroupBadgesMessageEvent = _sessionDataManager.communication.addHabboConnectionMessageEvent(new HabboGroupBadgesMessageEvent(onHabboGroupBadges));
            };
        }

        public function get disposed():Boolean
        {
            return (_sessionDataManager == null);
        }

        public function dispose():void
        {
            if (disposed)
            {
                return;
            };

            if (_sessionDataManager.communication)
            {
                _sessionDataManager.communication.removeHabboConnectionMessageEvent(_roomReadyMessageEvent);
                _sessionDataManager.communication.removeHabboConnectionMessageEvent(_habboGroupBadgesMessageEvent);
            };

            _badges = null;
            _sessionDataManager = null;
        }

        private function onRoomReady(_arg_1:IMessageEvent):void
        {
            _sessionDataManager.send(new GetHabboGroupBadgesMessageComposer());
        }

        private function onHabboGroupBadges(_arg_1:HabboGroupBadgesMessageEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:Map = _arg_1.badges;
            _local_4 = 0;

            while (_local_4 < _local_2.length)
            {
                _local_3 = _local_2.getKey(_local_4);
                _badges.remove(_local_3);
                _badges.add(_local_3, _local_2.getWithIndex(_local_4));
                _local_4++;
            };
        }

        public function getBadgeId(_arg_1:int):String
        {
            return (_badges.getValue(_arg_1));
        }

    }
}
