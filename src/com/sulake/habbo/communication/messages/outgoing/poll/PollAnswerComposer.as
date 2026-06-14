package com.sulake.habbo.communication.messages.outgoing.poll
{
    import com.sulake.core.communication.messages.IMessageComposer;

        public class PollAnswerComposer implements IMessageComposer 
    {

        private var _data:Array;

        public function PollAnswerComposer(_arg_1:int, _arg_2:int, _arg_3:Array)
        {
            var _local_4:int;
            super();
            _data = [_arg_1, _arg_2];
            _data.push(_arg_3.length);
            _local_4 = 0;

            while (_local_4 < _arg_3.length)
            {
                _data.push(_arg_3[_local_4]);
                _local_4++;
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
