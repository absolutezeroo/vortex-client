package com.sulake.habbo.avatar.wardrobe
{
    import com.sulake.habbo.avatar.common.ISideContentModel;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.communication.messages.incoming.avatar.OutfitData;

    public class WardrobeModel implements ISideContentModel 
    {

        private var _controller:HabboAvatarEditor;
        private var _view:WardrobeView;
        private var _slots:Map;
        private var _isInitialized:Boolean = false;

        public function WardrobeModel(_arg_1:HabboAvatarEditor)
        {
            _controller = _arg_1;
        }

        public function dispose():void
        {
            _controller = null;

            for each (var _local_1:WardrobeSlot in _slots)
            {
                _local_1.dispose();
                _local_1 = null;
            };

            _slots = null;

            if (_view)
            {
                _view.dispose();
                _view = null;
            };

            _isInitialized = false;
        }

        public function reset():void
        {
            _isInitialized = false;
        }

        private function init():void
        {
            var _local_1:int;

            if (_view)
            {
                _view.dispose();
            };

            _view = new WardrobeView(this);

            if (_controller.handler != null)
            {
                _controller.handler.getWardrobe();
            };

            if (_slots)
            {
                for each (var _local_2:WardrobeSlot in _slots)
                {
                    _local_2.dispose();
                    _local_2 = null;
                };
            };

            _slots = new Map();
            _local_1 = 1;

            while (_local_1 <= 10)
            {
                _slots.add(_local_1, new WardrobeSlot(_view.slotWindowTemplate, _controller, _local_1, isSlotEnabled(_local_1)));
                _local_1++;
            };

            _isInitialized = true;
            updateView();
        }

        public function get controller():HabboAvatarEditor
        {
            return (_controller);
        }

        public function getWindowContainer():IWindowContainer
        {
            if (!_isInitialized)
            {
                init();
            };

            return (_view.getWindowContainer());
        }

        private function updateView():void
        {
            _view.update();
        }

        public function updateSlots(_arg_1:int, _arg_2:Array):void
        {
            var _local_3:WardrobeSlot;

            if (!_isInitialized)
            {
                return;
            };

            if (!_arg_2)
            {
                ErrorReportStorage.addDebugData("WardrobeModel", "updateSlots: outfits is null!");
            };

            if (!_slots)
            {
                ErrorReportStorage.addDebugData("WardrobeModel", "updateSlots: _slots is null!");
            };

            for each (var _local_4:OutfitData in _arg_2)
            {
                _local_3 = (_slots.getValue(_local_4.slotId) as WardrobeSlot);

                if (_local_3)
                {
                    _local_3.update(_local_4.figureString, _local_4.gender, isSlotEnabled(_local_3.id));
                };
            };
        }

        private function isSlotEnabled(_arg_1:int):Boolean
        {
            if (_arg_1 <= 5)
            {
                return (_controller.manager.sessionData.hasClub);
            };

            return (_controller.manager.sessionData.hasVip);
        }

        public function get slots():Array
        {
            return (_slots.getValues());
        }

    }
}
