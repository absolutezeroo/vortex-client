package com.sulake.habbo.avatar.hotlooks
{
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.wardrobe.Outfit;
    import com.sulake.core.window.events.WindowEvent;

    public class HotLooksView implements IAvatarEditorCategoryView 
    {

        private var _window:IWindowContainer;
        private var _model:HotLooksModel;
        private var _hotLooksGrid:IItemGridWindow;

        public function HotLooksView(_arg_1:HotLooksModel)
        {
            _model = _arg_1;
        }

        public function init():void
        {
            if (_hotLooksGrid)
            {
                _hotLooksGrid.removeGridItems();
            };

            if (!_window)
            {
                _window = (_model.controller.view.getCategoryContainer("hotlooks") as IWindowContainer);
                _hotLooksGrid = (_window.findChildByName("hotlooks") as IItemGridWindow);
                _window.visible = false;
            };

            update();
        }

        public function dispose():void
        {
            _hotLooksGrid.removeGridItems();
            _window = null;
            _model = null;
        }

        public function update():void
        {
            var _local_2:IWindow;
            _hotLooksGrid.removeGridItems();

            for each (var _local_1:Outfit in _model.hotLooks)
            {
                _local_2 = _local_1.view.window;
                _hotLooksGrid.addGridItem(_local_2);
                _local_2.procedure = hotLooksEventProc;
            };
        }

        public function getWindowContainer():IWindowContainer
        {
            return (_window);
        }

        private function hotLooksEventProc(_arg_1:WindowEvent, _arg_2:IWindow=null):void
        {
            var _local_3:int;

            if (_arg_2 == null)
            {
                _arg_2 = (_arg_1.target as IWindow);
            };

            if (_arg_1.type == "WME_CLICK")
            {
                _local_3 = _hotLooksGrid.getGridItemIndex(_arg_2.parent);
                _model.selectHotLook(_local_3);
            };
        }

        public function switchCategory(_arg_1:String):void
        {
        }

        public function showPalettes(_arg_1:String, _arg_2:int):void
        {
        }

        public function reset():void
        {
        }

    }
}
