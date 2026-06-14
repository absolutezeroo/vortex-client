package com.sulake.habbo.ui.handler
{
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.requirementsmissing.CustomUserNotificationWidget;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.CustomUserNotificationMessageEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

    public class CustomUserNotificationWidgetHandler implements IRoomWidgetHandler 
    {

        private var _container:IRoomWidgetHandlerContainer = null;
        private var _disposed:Boolean = false;
        private var _widget:CustomUserNotificationWidget;
        private var _customUserNotificationListener:IMessageEvent;

        public function get type():String
        {
            return ("RWE_CUSTOM_USER_NOTIFICATION");
        }

        public function set widget(_arg_1:CustomUserNotificationWidget):void
        {
            _widget = _arg_1;
        }

        public function set container(_arg_1:IRoomWidgetHandlerContainer):void
        {
            _container = _arg_1;

            if (!_customUserNotificationListener)
            {
                _customUserNotificationListener = new CustomUserNotificationMessageEvent(onFurnitureUsageRequirementMissingMessage);
                _container.connection.addMessageEvent(_customUserNotificationListener);
            };
        }

        public function get container():IRoomWidgetHandlerContainer
        {
            return (_container);
        }

        public function getWidgetMessages():Array
        {
            return ([]);
        }

        public function processWidgetMessage(_arg_1:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return (null);
        }

        public function getProcessedEvents():Array
        {
            return (null);
        }

        public function processEvent(_arg_1:Event):void
        {
        }

        public function update():void
        {
        }

        public function dispose():void
        {
            if (!disposed)
            {
                if (((_container.connection) && (_customUserNotificationListener)))
                {
                    _container.connection.removeMessageEvent(_customUserNotificationListener);
                };

                _customUserNotificationListener = null;
                _widget = null;
                _container = null;
                _disposed = true;
            };
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function onFurnitureUsageRequirementMissingMessage(_arg_1:CustomUserNotificationMessageEvent):void
        {
            var _local_2:int = _arg_1.getParser().code;

            if (_widget)
            {
                switch (_local_2)
                {
                    case 1:
                        _widget.open("costumehopper");
                        return;
                    case 2:
                        _widget.open("viphopper");
                        return;
                    case 3:
                        _widget.open("vipgate");
                        return;
                    case 4:
                        _widget.open("respectfailedstage");
                        return;
                    case 5:
                        _widget.open("respectfailedaudience");
                    default:
                };
            };
        }

    }
}
