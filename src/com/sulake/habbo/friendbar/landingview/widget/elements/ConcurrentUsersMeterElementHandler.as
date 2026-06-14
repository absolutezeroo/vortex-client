package com.sulake.habbo.friendbar.landingview.widget.elements
{
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.ConcurrentUsersGoalProgressMessageEvent;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

    public class ConcurrentUsersMeterElementHandler implements IElementHandler, IFloatingElement 
    {

        private var _image:IStaticBitmapWrapperWindow;
        private var _state:int;
        private var _userCount:int;
        private var _userCountGoal:int;

        public function initialize(_arg_1:HabboLandingView, _arg_2:IWindow, _arg_3:Array, _arg_4:GenericWidget):void
        {
            _image = IStaticBitmapWrapperWindow(_arg_2);

            var _local_5:String = _arg_3[1];
            _image.assetUri = _local_5;
            _image.x = ((_arg_3.length > 2) ? _arg_3[2] : 0);
            _image.y = ((_arg_3.length > 3) ? _arg_3[3] : 0);
            Logger.log(("Init Concurrent users meter: " + _local_5));
            _arg_1.communicationManager.addHabboConnectionMessageEvent(new ConcurrentUsersGoalProgressMessageEvent(onConcurrentUsersGoalProgress));
        }

        public function refresh():void
        {
        }

        public function isFloating(_arg_1:Boolean):Boolean
        {
            return (true);
        }

        private function onConcurrentUsersGoalProgress(_arg_1:ConcurrentUsersGoalProgressMessageEvent):void
        {
            _state = _arg_1.getParser().state;
            _userCount = _arg_1.getParser().userCount;
            _userCountGoal = _arg_1.getParser().userCountGoal;

            var _local_3:int = int(((_userCount / _userCountGoal) * 100));
            _local_3 = Math.max(20, Math.min(100, _local_3));
            _local_3 = int((Math.floor((_local_3 / 10)) * 10));

            var _local_2:String = ("challenge_meter_" + _local_3);
            _image.assetUri = (("${image.library.url}reception/" + _local_2) + ".png");
            Logger.log(("Updating meter: " + _local_2));
        }

    }
}
