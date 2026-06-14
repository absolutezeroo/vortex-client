package com.sulake.habbo.communication.messages.outgoing.users
{
    import com.sulake.core.communication.messages.IMessageComposer;

        public class CreateGuildMessageComposer implements IMessageComposer 
    {

        private var _data:Array = [];

        public function CreateGuildMessageComposer(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:Array)
        {
            var _local_7:int;
            super();
            _data.push(_arg_1);
            _data.push(_arg_2);
            _data.push(_arg_3);
            _data.push(_arg_4);
            _data.push(_arg_5);
            _data.push(_arg_6.length);
            _local_7 = 0;

            while (_local_7 < _arg_6.length)
            {
                _data.push(_arg_6[_local_7]);
                _local_7++;
            };
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
