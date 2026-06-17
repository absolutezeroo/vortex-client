package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

        public class WiredRoomLogsEventParser implements IMessageParser
    {

        private var _page:WiredLogPage;

        public function flush():Boolean
        {
            _page = null;
            return (true);
        }

        public function parse(_arg_1:IMessageDataWrapper):Boolean
        {
            _page = new WiredLogPage(_arg_1);
            return (true);
        }

        public function get page():WiredLogPage
        {
            return (_page);
        }

    }
}
