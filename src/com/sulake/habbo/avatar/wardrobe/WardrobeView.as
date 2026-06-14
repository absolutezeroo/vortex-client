package com.sulake.habbo.avatar.wardrobe
{
    import com.sulake.habbo.avatar.common.ISideContentView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;

    public class WardrobeView implements ISideContentView 
    {

        private var _window:IWindowContainer;
        private var _model:WardrobeModel;
        private var _slotList:IItemListWindow;
        private var _vipSlotList:IItemListWindow;
        private var _slotWindowTemplate:IWindow;

        public function WardrobeView(_arg_1:WardrobeModel)
        {
            _model = _arg_1;

            var _local_2:XmlAsset = (_model.controller.manager.assets.getAssetByName("avatareditor_wardrobe_base") as XmlAsset);
            _window = (_model.controller.manager.windowManager.buildFromXML((_local_2.content as XML)) as IWindowContainer);
            _slotList = (_window.findChildByName("hc_slots") as IItemListWindow);
            _vipSlotList = (_window.findChildByName("vip_slots") as IItemListWindow);
            _slotWindowTemplate = _window.findChildByName("slot_template");

            if (_slotWindowTemplate)
            {
                _window.removeChild(_slotWindowTemplate);
            };

            _window.visible = false;
        }

        public function get slotWindowTemplate():IWindow
        {
            return (_slotWindowTemplate);
        }

        public function dispose():void
        {
            _model = null;
            _slotList = null;

            if (_window)
            {
                _window.dispose();
                _window = null;
            };
        }

        public function update():void
        {
            var _local_3:WardrobeSlot;
            var _local_2:int;

            if (_slotList)
            {
                _slotList.removeListItems();
            };

            if (_vipSlotList)
            {
                _vipSlotList.removeListItems();
            };

            var _local_1:Array = _model.slots;
            _local_2 = 0;

            while (_local_2 < _local_1.length)
            {
                _local_3 = _local_1[_local_2];

                if (_local_2 < 5)
                {
                    if (_slotList)
                    {
                        _slotList.addListItem(_local_3.view);
                        _local_3.view.visible = true;
                    };
                }

                else
                {
                    if (_vipSlotList)
                    {
                        _vipSlotList.addListItem(_local_3.view);
                        _local_3.view.visible = true;
                    };
                };

                _local_2++;
            };
        }

        public function getWindowContainer():IWindowContainer
        {
            return (_window);
        }

    }
}
