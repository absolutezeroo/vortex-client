package com.sulake.habbo.ui.widget.effects
{
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.ui.handler.EffectsWidgetHandler;
    import com.sulake.core.assets.XmlAsset;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.memenu.IWidgetAvatarEffect;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class EffectsWidget extends RoomWidgetBase 
    {

        private static const LIST_HEIGHT_MAX:int = 320;
        private static const LIST_HEIGHT_MIN:int = 48;
        private static const TOOLBAR_MARGIN:int = 2;

        private var _view:IWindowContainer;
        private var _list:IScrollableListWindow;
        private var _effectViews:Map;

        public function EffectsWidget(_arg_1:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.handler.widget = this;
            _effectViews = new Map();
        }

        public function get handler():EffectsWidgetHandler
        {
            return (_SafeStr_3915 as EffectsWidgetHandler);
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            };

            if (_effectViews)
            {
                for each (var _local_1:EffectView in _effectViews)
                {
                    _local_1.dispose();
                };

                _effectViews.dispose();
                _effectViews = null;
            };

            _list = null;

            if (_view)
            {
                _view.dispose();
                _view = null;
            };

            super.dispose();
        }

        public function open():void
        {
            var _local_2:XmlAsset;
            var _local_1:Rectangle;
            var _local_3:IWindow;

            if (!_view)
            {
                _local_2 = (assets.getAssetByName("effects_widget") as XmlAsset);
                _view = (windowManager.buildFromXML((_local_2.content as XML)) as IWindowContainer);
                _local_1 = handler.container.toolbar.getRect();
                _view.x = (_local_1.right + 2);
                _view.y = (_local_1.bottom - _view.height);
                _list = (_view.findChildByName("list") as IScrollableListWindow);
                _local_3 = _view.findChildByName("close");
                _local_3.addEventListener("WME_CLICK", onClose);
            };

            update();
            _view.visible = true;
        }

        public function update():void
        {
            var _local_1:EffectView;
            var _local_4:int;
            var _local_2:Array = this.handler.container.inventory.getAvatarEffects();

            for each (var _local_3:IWidgetAvatarEffect in _local_2)
            {
                _local_1 = (_effectViews.getValue(_local_3.type) as EffectView);

                if (_local_1)
                {
                    _local_1.update();
                }

                else
                {
                    _local_1 = new EffectView(this, _local_3);
                    _effectViews.add(_local_3.type, _local_1);
                    _list.addListItem(_local_1.window);
                };
            };

            _local_4 = (_effectViews.length - 1);

            while (_local_4 >= 0)
            {
                _local_1 = _effectViews.getWithIndex(_local_4);

                if (_local_2.indexOf(_local_1.effect) == -1)
                {
                    _list.removeListItem(_local_1.window);
                    _effectViews.remove(_effectViews.getKey(_local_4));
                    _local_1.dispose();
                };

                _local_4--;
            };

            var _local_5:int = _list.scrollableRegion.height;
            _list.height = Math.max(Math.min(_local_5, 320), 48);
            _view.findChildByName("no_effects").visible = (_local_2.length == 0);
        }

        public function selectEffect(_arg_1:int, _arg_2:Boolean):void
        {
            if (_arg_2)
            {
                handler.container.inventory.setEffectDeselected(_arg_1);
            }

            else
            {
                handler.container.inventory.setEffectSelected(_arg_1);
            };
        }

        private function onClose(_arg_1:WindowMouseEvent):void
        {
            _view.visible = false;
        }

    }
}
