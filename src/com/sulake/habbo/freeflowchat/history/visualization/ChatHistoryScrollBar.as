package com.sulake.habbo.freeflowchat.history.visualization
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class ChatHistoryScrollBar 
    {

        public static const RIGHT_MARGIN:int = 0;

        private var _scrollView:ChatHistoryScrollView;
        private var _displayObject:Sprite;
        private var _background:Sprite;
        private var _thumbTrack:Sprite;
        private var _dragStartY:int;
        private var _dragStartBufferTopY:int;
        private var _registeredStage:Stage;

        public function ChatHistoryScrollBar(_arg_1:ChatHistoryScrollView, _arg_2:HabboFreeFlowChat)
        {
            _scrollView = _arg_1;
            _thumbTrack = HabboFreeFlowChat.create9SliceSprite(new Rectangle(2, 2, 1, 1), (_arg_2.assets.getAssetByName("scrollbar_thumb").content as BitmapData));
            _thumbTrack.x = 2;
            _thumbTrack.y = 2;
            _background = HabboFreeFlowChat.create9SliceSprite(new Rectangle(2, 2, 5, 5), (_arg_2.assets.getAssetByName("scrollbar_back").content as BitmapData));
            _displayObject = new Sprite();
            _displayObject.addChild(_background);
            _displayObject.addChild(_thumbTrack);
            _thumbTrack.addEventListener("addedToStage", onAddedToStage);
            _thumbTrack.addEventListener("removedFromStage", onRemovedFromStage);
            _thumbTrack.addEventListener("mouseDown", mouseDownEventHandler);
        }

        public function set height(_arg_1:int):void
        {
            _background.height = _arg_1;
            updateThumbTrack();
        }

        public function get displayObject():Sprite
        {
            return (_displayObject);
        }

        public function updateThumbTrack():void
        {
            var _local_1:int = (_scrollView.topY + (_scrollView.viewPort.height - _background.height));
            _thumbTrack.height = Math.min((_background.height - 4), Math.max(5, int(((_background.height - 4) * (_background.height / _scrollView.bufferHeight)))));
            _thumbTrack.y = Math.min(((_background.height - 2) - _thumbTrack.height), Math.max(2, int((((_background.height - 4) * (Math.max(1, _local_1) / _scrollView.bufferHeight)) - (_thumbTrack.height / 2)))));
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            _registeredStage = _thumbTrack.stage;
        }

        private function onRemovedFromStage(_arg_1:Event):void
        {
            _registeredStage = null;
        }

        private function mouseDownEventHandler(_arg_1:Event):void
        {
            _dragStartY = MouseEvent(_arg_1).stageY;
            _dragStartBufferTopY = _scrollView.topY;
            _registeredStage.addEventListener("mouseUp", mouseDragEventHandler);
            _registeredStage.addEventListener("mouseMove", mouseDragEventHandler);
            _arg_1.stopImmediatePropagation();
        }

        private function mouseDragEventHandler(_arg_1:Event):void
        {
            var _local_4:Number;
            var _local_2:int;
            var _local_3:MouseEvent = MouseEvent(_arg_1);
            switch (_local_3.type)
            {
                case "mouseMove":
                    _local_4 = (_scrollView.bufferHeight / _background.height);
                    _local_2 = ((_local_3.stageY - _dragStartY) * _local_4);
                    _scrollView.topY = (_dragStartBufferTopY + _local_2);
                    break;
                case "mouseUp":
                    endScroll();
            };

            _arg_1.stopImmediatePropagation();
        }

        public function endScroll():void
        {
            if (_registeredStage)
            {
                _registeredStage.removeEventListener("mouseUp", mouseDragEventHandler);
                _registeredStage.removeEventListener("mouseMove", mouseDragEventHandler);
            };
        }

    }
}
