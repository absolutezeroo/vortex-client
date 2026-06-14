package com.sulake.habbo.ui.widget.chooser
{
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.events.RoomWidgetChooserContentEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;

    public class FurniChooserWidget extends ChooserWidgetBase 
    {

        private var _furniChooser:ChooserView;

        public function FurniChooserWidget(_arg_1:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override public function dispose():void
        {
            if (_furniChooser != null)
            {
                _furniChooser.dispose();
                _furniChooser = null;
            };

            super.dispose();
        }

        override public function registerUpdateEvents(_arg_1:IEventDispatcher):void
        {
            if (_arg_1 == null)
            {
                return;
            };

            _arg_1.addEventListener("RWCCE_FURNI_CHOOSER_CONTENT", onChooserContent);
            _arg_1.addEventListener("RWROUE_FURNI_REMOVED", onUpdateFurniChooser);
            _arg_1.addEventListener("RWROUE_FURNI_ADDED", onUpdateFurniChooser);
            super.registerUpdateEvents(_arg_1);
        }

        override public function unregisterUpdateEvents(_arg_1:IEventDispatcher):void
        {
            if (_arg_1 == null)
            {
                return;
            };

            _arg_1.removeEventListener("RWCCE_FURNI_CHOOSER_CONTENT", onChooserContent);
            _arg_1.removeEventListener("RWROUE_FURNI_REMOVED", onUpdateFurniChooser);
            _arg_1.removeEventListener("RWROUE_FURNI_ADDED", onUpdateFurniChooser);
        }

        private function onChooserContent(_arg_1:RoomWidgetChooserContentEvent):void
        {
            if (((_arg_1 == null) || (_arg_1.items == null)))
            {
                return;
            };

            if (_furniChooser == null)
            {
                _furniChooser = new ChooserView(this, "${widget.chooser.furni.title}");
            };

            _furniChooser.populate(_arg_1.items, _arg_1.isAnyRoomController);
        }

        private function onUpdateFurniChooser(_arg_1:RoomWidgetRoomObjectUpdateEvent):void
        {
            if (((_furniChooser == null) || (!(_furniChooser.isOpen()))))
            {
                return;
            };

            var _local_2:RoomWidgetRequestWidgetMessage = new RoomWidgetRequestWidgetMessage("RWRWM_FURNI_CHOOSER");
            messageListener.processWidgetMessage(_local_2);
        }

    }
}
