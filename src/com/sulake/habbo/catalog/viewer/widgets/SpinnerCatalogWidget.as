package com.sulake.habbo.catalog.viewer.widgets
{
    import com.sulake.habbo.catalog.HabboCatalog;
    import flash.utils.Timer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetSpinnerEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;

    public class SpinnerCatalogWidget extends CatalogWidget implements ICatalogWidget 
    {

        private static const SPIN_BUTTONDOWN_HOLD_VALUE_STEP_DELAY_MS:int = 75;
        private static const _SafeStr_1622:int = 35;

        private var _catalog:HabboCatalog;
        private var _value:int = 1;
        private var _minValue:int = 1;
        private var _maxValue:int = 100;
        private var _spinTimer:Timer;
        private var _moreButtonDown:Boolean = false;
        private var _lessButtonDown:Boolean = false;
        private var _ignoreNextClickEvent:Boolean = false;
        private var _holdStartedAt:int = 1;
        private var _skipSteps:Array = new Array(0);
        private var _promoInfo:IWindow;

        public function SpinnerCatalogWidget(_arg_1:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(_arg_1);
            _catalog = _arg_2;
        }

        override public function dispose():void
        {
            if (!disposed)
            {
                if (_spinTimer != null)
                {
                    _spinTimer.stop();
                    _spinTimer = null;
                };

                events.removeEventListener("CWSE_RESET", onRequestResetEvent);
                events.removeEventListener("CWSE_SHOW", onShowEvent);
                events.removeEventListener("CWSE_HIDE", onHideEvent);
                events.removeEventListener("CWSE_SET_MAX", onSetMaxEvent);
                events.removeEventListener("CWSE_SET_MIN", onSetMinEvent);
                super.dispose();
            };
        }

        override public function init():Boolean
        {
            if (!super.init())
            {
                return (false);
            };

            attachWidgetView("spinnerWidget");
            window.visible = false;

            if (!_catalog.multiplePurchaseEnabled)
            {
                return (true);
            };

            window.procedure = spinnerWindowProcedure;

            var _local_1:ITextFieldWindow = (window.findChildByName("text_value") as ITextFieldWindow);

            if (_local_1)
            {
                _local_1.addEventListener("WKE_KEY_UP", onInputEvent);
            };

            events.addEventListener("CWSE_RESET", onRequestResetEvent);
            events.addEventListener("CWSE_SHOW", onShowEvent);
            events.addEventListener("CWSE_HIDE", onHideEvent);
            events.addEventListener("CWSE_SET_MAX", onSetMaxEvent);
            events.addEventListener("CWSE_SET_MIN", onSetMinEvent);
            _spinTimer = new Timer(75);
            _spinTimer.addEventListener("timer", onSpinnerTimerEvent);
            _promoInfo = window.findChildByName("promo.info");
            return (true);
        }

        private function refresh():void
        {
            var _local_1:int;
            _value = Math.max(_value, _minValue);
            _value = Math.min(_value, _maxValue);
            events.dispatchEvent(new CatalogWidgetSpinnerEvent("CWSE_VALUE_CHANGED", _value));
            setValueText(_value.toString());

            if (((_promoInfo) && (_catalog.bundleDiscountEnabled)))
            {
                _local_1 = _catalog.utils.getDiscountItemsCount(_value);
                window.findChildByName("discountContainer").visible = (_local_1 > 0);
                _catalog.localization.registerParameter("shop.bonus.items.count", "amount", _local_1.toString());
            };
        }

        private function onRequestResetEvent(_arg_1:CatalogWidgetSpinnerEvent):void
        {
            _value = _arg_1.value;

            if (_arg_1.skipSteps != null)
            {
                _skipSteps = _arg_1.skipSteps;
            };

            refresh();
        }

        private function onShowEvent(_arg_1:CatalogWidgetSpinnerEvent):void
        {
            window.visible = true;
        }

        private function onHideEvent(_arg_1:CatalogWidgetSpinnerEvent):void
        {
            window.visible = false;
        }

        private function onSetMaxEvent(_arg_1:CatalogWidgetSpinnerEvent):void
        {
            _maxValue = _arg_1.value;
        }

        private function onSetMinEvent(_arg_1:CatalogWidgetSpinnerEvent):void
        {
            _minValue = _arg_1.value;
        }

        private function onSpinnerTimerEvent(_arg_1:TimerEvent):void
        {
            if (disposed)
            {
                return;
            };

            _ignoreNextClickEvent = true;

            if (_moreButtonDown)
            {
                increaseValue();

                if ((_value - _holdStartedAt) > 35)
                {
                    increaseValue();
                };
            };

            if (_lessButtonDown)
            {
                decreaseValue();

                if ((_holdStartedAt - _value) > 35)
                {
                    decreaseValue();
                };
            };

            refresh();
        }

        private function increaseValue():void
        {
            var _local_1:int = (_value + 1);

            while (_skipSteps.indexOf(_local_1) != -1)
            {
                _local_1++;
            };

            _value = _local_1;
        }

        private function decreaseValue():void
        {
            var _local_1:int = (_value - 1);

            while (_skipSteps.indexOf(_local_1) != -1)
            {
                _local_1--;
            };

            _value = _local_1;
        }

        private function setValueText(_arg_1:String):void
        {
            if (_window == null)
            {
                return;
            };

            if ((_window.findChildByName("text_value") is ITextFieldWindow))
            {
                if (_window.findChildByName("text_value").caption.length > 0)
                {
                    _window.findChildByName("text_value").caption = _arg_1;
                };
            }

            else
            {
                _window.findChildByName("text_value").caption = _arg_1;
            };
        }

        private function spinnerWindowProcedure(_arg_1:WindowEvent, _arg_2:IWindow=null):void
        {
            if (!_arg_1)
            {
                return;
            };

            if (((((!(_arg_1.type == "WME_CLICK")) && (!(_arg_1.type == "WME_DOWN"))) && (!(_arg_1.type == "WME_UP"))) && (!(_arg_1.type == "WME_UP_OUTSIDE"))))
            {
                return;
            };

            switch (_arg_1.target.name)
            {
                case "button_less":
                    switch (_arg_1.type)
                    {
                        case "WME_DOWN":
                            _lessButtonDown = true;
                            _holdStartedAt = _value;
                            _spinTimer.start();
                            break;
                        case "WME_UP":
                        case "WME_UP_OUTSIDE":
                            _lessButtonDown = false;
                            _spinTimer.stop();
                            break;
                        case "WME_CLICK":

                            if (!_ignoreNextClickEvent)
                            {
                                decreaseValue();
                            };

                            refresh();
                            _ignoreNextClickEvent = false;
                    };

                    return;
                case "button_more":
                    switch (_arg_1.type)
                    {
                        case "WME_DOWN":
                            _moreButtonDown = true;
                            _holdStartedAt = _value;
                            _spinTimer.start();
                            break;
                        case "WME_UP":
                        case "WME_UP_OUTSIDE":
                            _moreButtonDown = false;
                            _spinTimer.stop();
                            break;
                        case "WME_CLICK":

                            if (!_ignoreNextClickEvent)
                            {
                                increaseValue();
                            };

                            refresh();
                            _ignoreNextClickEvent = false;
                    };

                    return;
            };
        }

        private function onInputEvent(_arg_1:WindowKeyboardEvent):void
        {
            _value = parseInt(_arg_1.target.caption);
            refresh();
        }

    }
}
