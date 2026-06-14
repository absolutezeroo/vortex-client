package com.sulake.habbo.avatar.effects
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.utils.Timer;
    import com.sulake.habbo.avatar.IHabboAvatarEditorAvatarEffect;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.events.TimerEvent;

    public class EffectsParamView implements IDisposable 
    {

        private var _model:EffectsModel;
        private var _container:IWindowContainer;
        private var _catalogPageName:String;
        private var _windowManager:IHabboWindowManager;
        private var _secondsCounterTimer:Timer;
        private var _storedSeconds:int = 0;
        private var _storedEffect:IHabboAvatarEditorAvatarEffect = null;

        public function EffectsParamView(_arg_1:EffectsModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            _model = _arg_1;
            _windowManager = _arg_2;
            _container = _arg_1.controller.view.effectsParamViewContainer;
            _catalogPageName = _arg_1.controller.manager.getProperty("avatareditor.effects.buy.button.catalog.page.name");
            _secondsCounterTimer = new Timer(1000);
            _secondsCounterTimer.addEventListener("timer", onSecondsTimer);
            _container.findChildByName("get_more_button").addEventListener("WME_CLICK", onBuyButtonClick);
            updateView(null);
        }

        public function dispose():void
        {
            if (_secondsCounterTimer)
            {
                _secondsCounterTimer.stop();
                _secondsCounterTimer.removeEventListener("timer", onSecondsTimer);
                _secondsCounterTimer = null;
            };

            _windowManager = null;
            _model = null;
        }

        public function get disposed():Boolean
        {
            return (_model == null);
        }

        public function updateView(_arg_1:IHabboAvatarEditorAvatarEffect):void
        {
            _storedEffect = _arg_1;
            _container.visible = true;

            if (_arg_1 == null)
            {
                _container.findChildByName("time_left_bg").visible = false;
                _container.findChildByName("save_to_activate").visible = false;
                _container.findChildByName("effect_name").visible = false;
            }

            else
            {
                _container.findChildByName("effect_name").visible = true;

                if (((!(_arg_1.isActive)) && (!(_arg_1.isPermanent))))
                {
                    _container.findChildByName("time_left_bg").visible = false;
                    _container.findChildByName("save_to_activate").visible = true;
                    _secondsCounterTimer.stop();
                }

                else
                {
                    _storedSeconds = _arg_1.secondsLeft;
                    setSecondsLeft(_arg_1.secondsLeft, _arg_1.duration, _arg_1.isPermanent);
                    _container.findChildByName("time_left_bg").visible = true;
                    _container.findChildByName("save_to_activate").visible = false;
                    _secondsCounterTimer.start();
                };

                _container.findChildByName("effect_name").caption = (("${fx_" + _arg_1.type) + "}");
            };
        }

        private function setSecondsLeft(_arg_1:int, _arg_2:int, _arg_3:Boolean):void
        {
            var _local_17:String;
            var _local_16:int;
            var _local_18:int;
            var _local_7:int;
            var _local_9:int;
            var _local_13:int;
            var _local_10:String;
            var _local_14:String;
            var _local_15:String;
            var _local_5:IWindowContainer = (_container.findChildByName("time_left_bg") as IWindowContainer);
            var _local_12:IBitmapWrapperWindow = IBitmapWrapperWindow(_local_5.findChildByName("progress_bar_bitmap"));
            var _local_6:BitmapData = new BitmapData(_local_12.width, _local_12.height, false, 0);
            var _local_4:int = ((_arg_3) ? _arg_2 : _arg_1);
            var _local_8:Rectangle = new Rectangle(0, 0, int((_local_6.width * (_local_4 / _arg_2))), _local_6.height);
            _local_6.fillRect(_local_8, 2146080);
            _local_12.bitmap = _local_6;

            var _local_11:ITextWindow = ITextWindow(_local_5.findChildByName("effect_time_left"));

            if (_arg_3)
            {
                _local_11.caption = "${avatareditor.effects.active.permanent}";
                _local_17 = _local_11.text;
            }

            else
            {
                if (_arg_1 > 86400)
                {
                    _local_11.caption = "${avatareditor.effects.active.daysleft}";
                    _local_17 = _local_11.text;
                    _local_16 = int(Math.floor((_arg_1 / 86400)));
                    _local_17 = _local_17.replace("%days_left%", _local_16);
                }

                else
                {
                    _local_11.caption = "${avatareditor.effects.active.timeleft}";
                    _local_17 = _local_11.text;
                    _local_18 = _arg_1;
                    _local_7 = int(Math.floor((_local_18 / 3600)));
                    _local_9 = int((Math.floor((_local_18 / 60)) % 60));
                    _local_13 = (_local_18 % 60);
                    _local_10 = ((_local_7 < 10) ? "0" : "");
                    _local_14 = ((_local_9 < 10) ? "0" : "");
                    _local_15 = ((_local_13 < 10) ? "0" : "");

                    if (_local_7 > 0)
                    {
                        _local_17 = _local_17.replace("%time_left%", (((((((_local_10 + _local_7) + ":") + _local_14) + _local_9) + ":") + _local_15) + _local_13));
                    }

                    else
                    {
                        _local_17 = _local_17.replace("%time_left%", ((((_local_14 + _local_9) + ":") + _local_15) + _local_13));
                    };
                };
            };

            _local_11.text = _local_17;
        }

        private function onBuyButtonClick(_arg_1:WindowMouseEvent):void
        {
            _model.controller.manager.catalog.openCatalogPage(_catalogPageName);
        }

        private function onSecondsTimer(_arg_1:TimerEvent):void
        {
            if (((!(_storedEffect == null)) && (_storedEffect.isActive)))
            {
                setSecondsLeft(_storedSeconds--, _storedEffect.duration, _storedEffect.isPermanent);
            };
        }

    }
}
