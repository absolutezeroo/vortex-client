package com.sulake.habbo.communication.messages.outgoing.friendlist
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

        public class SendRoomInviteMessageComposer implements IMessageComposer, IDisposable 
    {

        private var _invitedAvatarIds:Array = [];
        private var _msg:String;

        public function SendRoomInviteMessageComposer(_arg_1:String)
        {
            this._msg = _arg_1;
        }

        public function getMessageArray():Array
        {
            var _local_2:int;
            var _local_1:Array = [];
            _local_1.push(this._invitedAvatarIds.length);
            _local_2 = 0;

            while (_local_2 < this._invitedAvatarIds.length)
            {
                _local_1.push(this._invitedAvatarIds[_local_2]);
                _local_2++;
            };

            _local_1.push(this._msg);
            return (_local_1);
        }

        public function addInvitedFriend(_arg_1:int):void
        {
            this._invitedAvatarIds.push(_arg_1);
        }

        public function dispose():void
        {
            this._invitedAvatarIds = null;
        }

        public function get disposed():Boolean
        {
            return (false);
        }

    }
}
