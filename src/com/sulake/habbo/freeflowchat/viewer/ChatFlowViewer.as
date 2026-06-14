package com.sulake.habbo.freeflowchat.viewer
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.viewer.simulation.ChatFlowStage;
    import flash.display.DisplayObjectContainer;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.freeflowchat.viewer.visualization.PooledChatBubble;
    import flash.display.Sprite;
    import flash.geom.Point;

    public class ChatFlowViewer implements IDisposable, IUpdateReceiver 
    {

        private const VIEW_BOTTOM_DEFAULT:int = 230;

        private var _component:HabboFreeFlowChat;
        private var _chatFlowStage:ChatFlowStage;
        private var _rootDisplayObject:DisplayObjectContainer;
        private var _lastAddedToRoomId:int;
        private var _lastCanvasOffsetX:int = 0;
        private var _runTime:uint = 0;
        private var _chatAreaVsScreenSize:Number = 0.25;
        private var _bubbles:Vector.<PooledChatBubble> = new Vector.<PooledChatBubble>(0);
        private var _toRemove:Vector.<PooledChatBubble> = new Vector.<PooledChatBubble>(0);

        public function ChatFlowViewer(_arg_1:HabboFreeFlowChat, _arg_2:ChatFlowStage)
        {
            _rootDisplayObject = new Sprite();
            _component = _arg_1;
            _component.registerUpdateReceiver(this, 1);
            _chatFlowStage = _arg_2;
        }

        public function dispose():void
        {
            if (_component)
            {
                _component.removeUpdateReceiver(this);
                _component = null;
            };

            _chatFlowStage = null;
            _rootDisplayObject = null;
        }

        public function get disposed():Boolean
        {
            return ((_rootDisplayObject == null) && (_component == null));
        }

        public function insertBubble(_arg_1:PooledChatBubble, _arg_2:Point):void
        {
            _arg_1.roomPanOffsetX = _lastCanvasOffsetX;
            _bubbles.push(_arg_1);
            _rootDisplayObject.addChild(_arg_1);
            _arg_1.warpTo(_arg_2.x, _arg_2.y);
            _arg_1.repositionPointer();
            _lastAddedToRoomId = _arg_1.roomId;
        }

        public function update(_arg_1:uint):void
        {
            var _local_6:int;
            _runTime = (_runTime + _arg_1);

            var _local_3:Point = _component.roomEngine.getRoomCanvasScreenOffset(_lastAddedToRoomId);

            if (_local_3 != null)
            {
                if (((!(_local_3.x == _lastCanvasOffsetX)) && (_bubbles.length > 0)))
                {
                    for each (var _local_2:PooledChatBubble in _bubbles)
                    {
                        _local_2.roomPanOffsetX = _local_3.x;
                    };
                };

                _lastCanvasOffsetX = _local_3.x;
            };

            for each (var _local_4:PooledChatBubble in _bubbles)
            {
                _local_4.update(_arg_1);

                if (_local_4.readyToRecycle)
                {
                    _toRemove.push(_local_4);
                };
            };

            if (_toRemove.length > 0)
            {
                for each (var _local_5:PooledChatBubble in _toRemove)
                {
                    _rootDisplayObject.removeChild(_local_5);
                    _local_6 = _bubbles.indexOf(_local_5);
                    _bubbles.splice(_local_6, 1);
                    _local_5.unregister();
                    _component.chatBubbleFactory.recycle(_local_5);
                };

                _toRemove = new Vector.<PooledChatBubble>(0);
            };
        }

        public function get rootDisplayObject():DisplayObjectContainer
        {
            return (_rootDisplayObject);
        }

        public function get viewBottom():int
        {
            if (!_rootDisplayObject.stage)
            {
                return (230);
            };

            return (_rootDisplayObject.stage.stageHeight * _chatAreaVsScreenSize);
        }

        public function resize(_arg_1:int, _arg_2:int):void
        {
            if (_chatFlowStage)
            {
                _chatFlowStage.resize(_arg_1, _arg_2);
            };
        }

    }
}
