package com.sulake.habbo.communication.messages.parser.help
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

        public class GuideSessionInvitedToGuideRoomMessageParser implements IMessageParser 
    {

        private var _roomId:int = 0;
        private var _roomName:String = "";

        public function flush():Boolean
        {
            return (true);
        }

        public function parse(_arg_1:IMessageDataWrapper):Boolean
        {
            _roomId = _arg_1.readInteger();
            _roomName = _arg_1.readString();
            return (true);
        }

        public function getRoomId():int
        {
            return (_roomId);
        }

        public function getRoomName():String
        {
            return (_roomName);
        }

    }
}
