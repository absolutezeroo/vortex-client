package com.sulake.habbo.notifications.singular
{
    public class HabboNotificationItem 
    {

        private var _style:HabboNotificationItemStyle;
        private var _content:String;
        private var _controller:SingularNotificationController;

        public function HabboNotificationItem(_arg_1:String, _arg_2:HabboNotificationItemStyle, _arg_3:SingularNotificationController)
        {
            _content = _arg_1;
            _style = _arg_2;
            _controller = _arg_3;
        }

        public function get style():HabboNotificationItemStyle
        {
            return (_style);
        }

        public function get content():String
        {
            return (_content);
        }

        public function dispose():void
        {
            _content = null;

            if (_style != null)
            {
                _style.dispose();
                _style = null;
            };

            _controller = null;
        }

        public function ExecuteUiLinks():void
        {
            if (_style.internalLink)
            {
                _controller.onInternalLink(_style.internalLink);
            };
        }

    }
}
