package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredRoomLogsEventParser;

        public class WiredRoomLogsEvent extends MessageEvent implements IMessageEvent
    {

        public function WiredRoomLogsEvent(_arg_1:Function)
        {
            super(_arg_1, WiredRoomLogsEventParser);
        }

        public function getParser():WiredRoomLogsEventParser
        {
            return (this._SafeStr_816 as WiredRoomLogsEventParser);
        }

    }
}
