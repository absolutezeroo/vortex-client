package com.sulake.habbo.communication.messages.outgoing.room.engine
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class IssuePetCommandMessageComposer implements IMessageComposer
    {

        private var _data:Array = [];

        public function IssuePetCommandMessageComposer(_arg_1:int, _arg_2:int)
        {
            _data.push(_arg_1);
            _data.push(_arg_2);
        }

        public function getMessageArray():Array
        {
            return (_data);
        }

        public function dispose():void
        {
            _data = null;
        }

    }
}
