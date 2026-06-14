package com.sulake.habbo.friendbar.landingview.widget
{
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.catalog.LimitedOfferAppearingNextMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.catalog._SafeStr_26;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ICountdownWidget;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;

    public class NextLimitedRareCountdownWidget implements ILandingViewWidget, IProductDataListener, ISettingsAwareWidget 
    {

        private static const REFRESH_PERIOD_IN_MILLIS:Number = 30000;

        private var _landingView:HabboLandingView;
        private var _container:IWindowContainer;
        private var _appearsInSeconds:int = 0;
        private var _pageId:int;
        private var _offerId:int;
        private var _productType:String;
        private var _lastRequestTime:Date;
        private var _modeSwitchTimer:Timer;

        public function NextLimitedRareCountdownWidget(_arg_1:HabboLandingView)
        {
            _landingView = _arg_1;
        }

        public function dispose():void
        {
            if (!disposed)
            {
                if (_modeSwitchTimer != null)
                {
                    _modeSwitchTimer.stop();
                    _modeSwitchTimer = null;
                };

                _landingView = null;
                _container = null;
            };
        }

        public function get disposed():Boolean
        {
            return (_container == null);
        }

        public function initialize():void
        {
            _container = IWindowContainer(_landingView.getXmlWindow("next_ltd_available"));
            _container.findChildByName("get").procedure = onOpenCatalogButton;
            _container.findChildByName("catalogue_button").procedure = onOpenCatalogButton;
            _container.visible = false;
            _landingView.communicationManager.addHabboConnectionMessageEvent(new LimitedOfferAppearingNextMessageEvent(onLimitedOfferAppearingNextMessage));
            requestLimitedOfferAppearingNextMessage(null);
        }

        private function requestLimitedOfferAppearingNextMessage(_arg_1:TimerEvent):void
        {
            if (!_landingView.getBoolean("next.limited.rare.countdown.widget.disabled"))
            {
                _landingView.communicationManager.connection.send(new _SafeStr_26());
            };
        }

        public function refresh():void
        {
            if (((_lastRequestTime == null) || ((_lastRequestTime.time + 30000) < new Date().time)))
            {
                requestLimitedOfferAppearingNextMessage(null);
                _lastRequestTime = new Date();
            };
        }

        public function get container():IWindow
        {
            return (_container);
        }

        public function productDataReady():void
        {
            refreshContent();
        }

        private function refreshContent():void
        {
            if (disposed)
            {
                return;
            };

            if (_landingView.getProductData(_productType, this) != null)
            {
                _container.findChildByName("get").caption = _landingView.getProductData(_productType, this).name;
            };

            if (_pageId >= 0)
            {
                _container.visible = true;
                _container.findChildByName("get").visible = true;
                _container.findChildByName("countdown").visible = false;
            }

            else
            {
                if (_appearsInSeconds > 0)
                {
                    _container.visible = true;
                    _container.findChildByName("get").visible = false;
                    _container.findChildByName("countdown").visible = true;
                }

                else
                {
                    _container.visible = false;
                };
            };

            refreshTimer();
        }

        private function refreshTimer():void
        {
            var _local_1:IWidgetWindow = IWidgetWindow(_container.findChildByName("countdown"));
            var _local_2:ICountdownWidget = ICountdownWidget(_local_1.widget);
            _local_2.seconds = _appearsInSeconds;
            _local_2.running = true;
        }

        private function setModeSwitchTimer(_arg_1:int):void
        {
            if (_arg_1 <= 0)
            {
                return;
            };

            if (_modeSwitchTimer != null)
            {
                _modeSwitchTimer.stop();
                _modeSwitchTimer = null;
            };

            _modeSwitchTimer = new Timer(((_arg_1 + 1) * 1000), 1);
            _modeSwitchTimer.addEventListener("timer", requestLimitedOfferAppearingNextMessage);
            _modeSwitchTimer.start();
        }

        private function onLimitedOfferAppearingNextMessage(_arg_1:LimitedOfferAppearingNextMessageEvent):void
        {
            _appearsInSeconds = _arg_1.getParser().appearsInSeconds;
            _pageId = _arg_1.getParser().pageId;
            _offerId = _arg_1.getParser().offerId;
            _productType = _arg_1.getParser().productType;
            refreshContent();
            setModeSwitchTimer(_appearsInSeconds);
        }

        private function onOpenCatalogButton(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type == "WME_CLICK")
            {
                _landingView.catalog.openCatalogPageById(_pageId, _offerId, "NORMAL");
                _landingView.tracking.trackGoogle("landingView", "click_goToNextLimitedCatalogPage");
            };
        }

        public function set settings(_arg_1:CommonWidgetSettings):void
        {
            WidgetContainerLayout.applyCommonWidgetSettings(_container, _arg_1);
        }

    }
}
