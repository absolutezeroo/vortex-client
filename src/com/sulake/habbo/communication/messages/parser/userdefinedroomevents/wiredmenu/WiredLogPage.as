package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

        public class WiredLogPage
    {

        private var _totalEntries:int;
        private var _currentPage:int;
        private var _amount:int;
        private var _elements:Vector.<WiredLogEntry>;
        private var _logLevelFilter:int = -1;
        private var _logSourceFilter:int = -1;
        private var _query:String = null;

        public function WiredLogPage(_arg_1:IMessageDataWrapper)
        {
            _totalEntries = _arg_1.readInteger();
            _currentPage = _arg_1.readInteger();
            _amount = _arg_1.readInteger();
            _elements = new Vector.<WiredLogEntry>();
            var _local_2:int = _arg_1.readInteger();
            var _local_3:int = 0;
            while (_local_3 < _local_2)
            {
                _elements.push(new WiredLogEntry(_arg_1));
                _local_3++;
            }
            if (_arg_1.readBoolean())
            {
                _logLevelFilter = _arg_1.readByte();
            }
            if (_arg_1.readBoolean())
            {
                _logSourceFilter = _arg_1.readByte();
            }
            if (_arg_1.readBoolean())
            {
                _query = _arg_1.readString();
            }
        }

        public function get totalEntries():int
        {
            return (_totalEntries);
        }

        public function get currentPage():int
        {
            return (_currentPage);
        }

        public function get amount():int
        {
            return (_amount);
        }

        public function get elements():Vector.<WiredLogEntry>
        {
            return (_elements);
        }

        public function get logLevelFilter():int
        {
            return (_logLevelFilter);
        }

        public function get logSourceFilter():int
        {
            return (_logSourceFilter);
        }

        public function get query():String
        {
            return (_query);
        }

    }
}
