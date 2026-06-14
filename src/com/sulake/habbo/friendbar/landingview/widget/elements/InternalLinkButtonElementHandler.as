package com.sulake.habbo.friendbar.landingview.widget.elements
{
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

    public class InternalLinkButtonElementHandler extends AbstractButtonElementHandler 
    {

        private var _link:String;
        private var _configurationCode:String;

        override public function initialize(_arg_1:HabboLandingView, _arg_2:IWindow, _arg_3:Array, _arg_4:GenericWidget):void
        {
            super.initialize(_arg_1, _arg_2, _arg_3, _arg_4);
            _link = _arg_3[2];
            _configurationCode = _arg_4.configurationCode;
        }

        override protected function onClick():void
        {
            landingView.context.createLinkEvent(_link);
            landingView.tracking.trackEventLog("LandingView", _configurationCode, "client_link", _link);
        }

    }
}
