package com.sulake.habbo.friendbar.landingview.widget.elements
{
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.habbo.communication.messages.parser.inventory.badges.IsBadgeRequestFulfilledEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredRewardResultMessageEvent;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.habbo.communication.messages.outgoing.inventory.badges.GetIsBadgeRequestFulfilledComposer;

    public class RequestBadgeButtonElementHandler extends AbstractButtonElementHandler implements IFloatingElement 
    {

        private var _badgeRequestCode:String;
        private var _isFloating:Boolean = true;

        override public function initialize(_arg_1:HabboLandingView, _arg_2:IWindow, _arg_3:Array, _arg_4:GenericWidget):void
        {
            super.initialize(_arg_1, _arg_2, _arg_3, _arg_4);
            _badgeRequestCode = _arg_3[2];
            _arg_2.x = _arg_3[3];
            _arg_2.y = _arg_3[4];

            if (_arg_3.length > 5)
            {
                _isFloating = (_arg_3[5] == "true");
            };

            _arg_1.communicationManager.addHabboConnectionMessageEvent(new IsBadgeRequestFulfilledEvent(onInfo));
            _arg_1.communicationManager.addHabboConnectionMessageEvent(new WiredRewardResultMessageEvent(onReward));
        }

        override protected function onClick():void
        {
            landingView.requestBadge(_badgeRequestCode);
            landingView.tracking.trackGoogle("landingView", ("click_requestbadge_" + _badgeRequestCode));
        }

        override public function refresh():void
        {
            super.refresh();
            landingView.send(new GetIsBadgeRequestFulfilledComposer(_badgeRequestCode));
        }

        public function isFloating(_arg_1:Boolean):Boolean
        {
            return (_isFloating);
        }

        private function onInfo(_arg_1:IsBadgeRequestFulfilledEvent):void
        {
            if (_arg_1.getParser().requestCode == _badgeRequestCode)
            {
                window.visible = (!(_arg_1.getParser().fulfilled));
            };
        }

        private function onReward(_arg_1:WiredRewardResultMessageEvent):void
        {
            if (window)
            {
                landingView.send(new GetIsBadgeRequestFulfilledComposer(_badgeRequestCode));
            };
        }

    }
}
