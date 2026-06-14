package com.sulake.habbo.freeflowchat.history.visualization
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class ChatHistoryTray implements IDisposable, IUpdateReceiver 
    {

        private var _rootDisplayObject:DisplayObjectContainer;
        private var _registeredStage:Stage;
        private var _component:HabboFreeFlowChat;
        private var _scrollView:ChatHistoryScrollView;
        private var _tab:Sprite;
        private var _tabBg:Bitmap;
        private var _tabHandle:Bitmap;
        private var _bg:Bitmap;
        private var _openedWidth:int;
        private var _flagUpdateDisableRoomMouseEvents:Boolean = false;

        public function ChatHistoryTray(_arg_1:HabboFreeFlowChat, _arg_2:ChatHistoryScrollView)
        {
            _component = _arg_1;
            _scrollView = _arg_2;
            _rootDisplayObject = new Sprite();
            _tabBg = new Bitmap();
            _tabBg.bitmapData = BitmapData(_component.assets.getAssetByName("tray_bar").content);
            _tabBg.width = _tabBg.bitmapData.width;
            _tabBg.height = 0;
            _tabBg.scaleX = 1;
            _tabBg.x = -(_tabBg.bitmapData.width);
            _tabHandle = new Bitmap();
            _tabHandle.bitmapData = BitmapData(_component.assets.getAssetByName("tray_handle_open").content);
            _tabHandle.scaleX = 1;
            _tabHandle.scaleY = 1;
            _tabHandle.x = -(0);
            _tabHandle.y = 350;
            _tabHandle.visible = false;
            _tab = new Sprite();
            _tab.scaleX = 1;
            _tab.scaleY = 1;
            _tab.visible = true;
            _tab.addChild(_tabBg);
            _tab.addChild(_tabHandle);
            _rootDisplayObject.addChild(_tab);
            _bg = new Bitmap();
            _bg.bitmapData = new BitmapData(1, 1, true, 2720277278);
            _bg.width = 0;
            _bg.height = 0;
            _rootDisplayObject.addChild(_bg);
            _rootDisplayObject.addEventListener("addedToStage", onAddedToStage);
            _openedWidth = ((350 + 62) + 1);
        }

        public function dispose():void
        {
            _component.disableRoomMouseEventsLeftOfX(0);

            if (_rootDisplayObject)
            {
                _scrollView.deactivateScrolling();

                if (_registeredStage)
                {
                    _registeredStage.removeEventListener("mouseDown", stageMouseClickedEventHandler);
                };
            };

            _rootDisplayObject = null;
        }

        public function get disposed():Boolean
        {
            return (_rootDisplayObject == null);
        }

        public function get rootDisplayObject():DisplayObjectContainer
        {
            return (_rootDisplayObject);
        }

        public function resize(_arg_1:int, _arg_2:int):void
        {
            _tab.height = (_arg_2 - 50);
            _tabBg.height = (_arg_2 - 50);
            _bg.height = (_arg_2 - 50);
            _tab.scaleY = 1;
            _tabHandle.scaleY = 1;
            _tabHandle.y = (_arg_2 - 215);
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            resize(_rootDisplayObject.stage.stageWidth, _rootDisplayObject.stage.stageHeight);
            _rootDisplayObject.stage.addEventListener("click", stageMouseClickedEventHandler);
            _registeredStage = _rootDisplayObject.stage;
        }

        public function toggleHistoryVisibility():void
        {
            if (_scrollView.isActive)
            {
                _scrollView.deactivateScrolling();
                _rootDisplayObject.removeChild(_scrollView.rootDisplayObject);
                _scrollView.deactivateView();
                _bg.width = 0;
                _tabBg.x = -(_tabBg.bitmapData.width);
                _tabHandle.x = -(0);
                _tabHandle.visible = false;
                _scrollView.viewWidth = 0;
                _tabHandle.bitmapData = BitmapData(_component.assets.getAssetByName("tray_handle_open").content);
            }

            else
            {
                _rootDisplayObject.addChild(_scrollView.rootDisplayObject);
                _scrollView.scrollToBottom();
                _scrollView.activateScrolling();
                _scrollView.activateView();
                _bg.width = _openedWidth;
                _tabBg.x = _openedWidth;
                _tabHandle.visible = true;
                _tabHandle.x = ((_openedWidth - 0) + _tabBg.bitmapData.width);
                _scrollView.viewWidth = _openedWidth;
                _tabHandle.bitmapData = BitmapData(_component.assets.getAssetByName("tray_handle_close").content);
            };

            _flagUpdateDisableRoomMouseEvents = true;
        }

        private function stageMouseClickedEventHandler(_arg_1:Event):void
        {
            if (((!(_rootDisplayObject)) || (!(_rootDisplayObject.stage))))
            {
                return;
            };

            var _local_2:MouseEvent = MouseEvent(_arg_1);

            if ((((((_scrollView.isActive) && (_tabHandle.x <= _local_2.stageX)) && (_local_2.stageX <= (_tabHandle.x + _tabHandle.width))) && (_tabHandle.y <= _local_2.stageY)) && (_local_2.stageY <= (_tabHandle.y + _tabHandle.height))))
            {
                toggleHistoryVisibility();
            };
        }

        public function update(_arg_1:uint):void
        {
            if (((_flagUpdateDisableRoomMouseEvents) && (_arg_1 > 20)))
            {
                _component.disableRoomMouseEventsLeftOfX(((_scrollView.isActive) ? (_openedWidth + _tabBg.bitmapData.width) : 0));
                _flagUpdateDisableRoomMouseEvents = false;
            };
        }

    }
}
