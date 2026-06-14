package com.sulake.habbo.communication.messages.outgoing.moderator
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

        public class ReleaseIssuesMessageComposer implements IMessageComposer, IDisposable 
    {

        private var _array:Array = [];

        public function ReleaseIssuesMessageComposer(_arg_1:Array)
        {
            var _local_2:int;
            super();
            this._array.push(_arg_1.length);
            _local_2 = 0;

            while (_local_2 < _arg_1.length)
            {
                this._array.push(_arg_1[_local_2]);
                _local_2++;
            };
        }

        public function getMessageArray():Array
        {
            return (this._array);
        }

        public function dispose():void
        {
            this._array = null;
        }

        public function get disposed():Boolean
        {
            return (false);
        }

    }
}
