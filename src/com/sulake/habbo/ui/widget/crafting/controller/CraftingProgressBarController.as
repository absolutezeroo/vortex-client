package com.sulake.habbo.ui.widget.crafting.controller
{
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import flash.utils.Timer;
    import com.sulake.core.window.IWindow;
    import flash.events.TimerEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindowContainer;

    public class CraftingProgressBarController 
    {

        private var _widget:CraftingWidget;
        private var _progressTimer:Timer;
        private var _progress:Number;

        public function CraftingProgressBarController(_arg_1:CraftingWidget)
        {
            _widget = _arg_1;
            _progressTimer = new Timer(70);
            _progressTimer.addEventListener("timer", onProgressTimerEvent);
        }

        public function dispose():void
        {
            _widget = null;
        }

        private function setProgress(_arg_1:Number):void
        {
            var _local_3:IWindow;
            var _local_2:IWindow = container.findChildByName("btn_cancel");
            var _local_4:IWindow = ((container) ? container.findChildByName("bar") : null);

            if (_local_4)
            {
                _local_3 = _local_4.parent;
                _local_4.width = (_local_2.width * _arg_1);
            };
        }

        private function onProgressTimerEvent(_arg_1:TimerEvent):void
        {
            var _local_2:Number = (_progress + 0.02);
            _progress = _local_2;
            setProgress(_local_2);

            if (_progress >= 1)
            {
                hide();
                _widget.infoCtrl.onProgressBarComplete();
            };
        }

        public function hide():void
        {
            if (_progressTimer)
            {
                _progressTimer.stop();
            };

            if (container)
            {
                container.visible = false;
                container.procedure = null;
            };
        }

        public function show():void
        {
            _progressTimer.start();
            _progress = 0;

            if (container)
            {
                container.visible = true;
                container.procedure = onTriggered;
            };
        }

        private function onTriggered(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_DOWN")
            {
                return;
            };

            _widget.infoCtrl.cancelCrafting();
        }

        private function get container():IWindowContainer
        {
            if (((!(_widget)) || (!(_widget.window))))
            {
                return (null);
            };

            return (_widget.window.findChildByName("progress_bar") as IWindowContainer);
        }

    }
}
