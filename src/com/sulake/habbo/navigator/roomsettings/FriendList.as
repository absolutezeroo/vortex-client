package com.sulake.habbo.navigator.roomsettings
{
    import flash.utils.Dictionary;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListFragmentMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.FriendsListFragmentMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendData;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListUpdateEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.FriendListUpdateMessageParser;

    public class FriendList
    {

        private var _namesById:Dictionary = new Dictionary();
        private var _list:Array;

        public function onFriendsListFragment(_arg_1:IMessageEvent):void
        {
            var _local_2:FriendsListFragmentMessageParser = (_arg_1 as FriendListFragmentMessageEvent).getParser();

            if (_local_2 == null)
            {
                return;
            };

            for each (var _local_3:FriendData in _local_2.friendFragment)
            {
                _namesById[_local_3.id] = _local_3.name;
            };
        }

        public function onFriendListUpdate(_arg_1:IMessageEvent):void
        {
            var _local_2:FriendListUpdateMessageParser = (_arg_1 as FriendListUpdateEvent).getParser();

            for each (var _local_3:int in _local_2.removedFriendIds)
            {
                _namesById[_local_3] = null;
            };

            for each (var _local_4:FriendData in _local_2.addedFriends)
            {
                _namesById[_local_4.id] = _local_4.name;
            };

            _list = (((_local_2.removedFriendIds.length > 0) || (_local_2.addedFriends.length > 0)) ? null : _list);
        }

        public function get list():Array
        {
            var _local_3:int;
            var _local_2:String;

            if (_list == null)
            {
                _list = [];

                for (var _local_1:String in _namesById)
                {
                    _local_3 = int(_local_1);
                    _local_2 = _namesById[_local_3];

                    if (_local_2 != null)
                    {
                        _list.push(new FriendEntryData(_local_3, _local_2));
                    };
                };

                _list.sortOn("userName", Array.CASEINSENSITIVE);
            };

            return (_list);
        }

    }
}