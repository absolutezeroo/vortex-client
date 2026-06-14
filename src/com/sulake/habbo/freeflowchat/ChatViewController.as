package com.sulake.habbo.freeflowchat
{
    import com.sulake.core.runtime.IDisposable;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import com.sulake.habbo.freeflowchat.viewer.ChatFlowViewer;
    import com.sulake.habbo.freeflowchat.history.visualization.ChatHistoryTray;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;

    public class ChatViewController implements IDisposable 
    {

        private var _rootDisplayObject:DisplayObjectContainer;
        private var _registeredStage:Stage;
        private var _component:HabboFreeFlowChat;
        private var _flowViewer:ChatFlowViewer;
        private var _pulldown:ChatHistoryTray;
        private var _flowViewerDisplayObject:DisplayObject;
        private var _pulldownDisplayObject:DisplayObject;

        public function ChatViewController(_arg_1:HabboFreeFlowChat, _arg_2:ChatFlowViewer, _arg_3:ChatHistoryTray)
        {
            _component = _arg_1;
            _flowViewer = _arg_2;
            _pulldown = _arg_3;
            _flowViewerDisplayObject = _flowViewer.rootDisplayObject;
            _pulldownDisplayObject = _pulldown.rootDisplayObject;
            _rootDisplayObject = new Sprite();
            _rootDisplayObject.addChild(_flowViewerDisplayObject);
            _rootDisplayObject.addChild(_pulldownDisplayObject);
            _rootDisplayObject.addEventListener("addedToStage", onAddedToStage);
        }

        public function dispose():void
        {
            if (_rootDisplayObject)
            {
                _component.removeUpdateReceiver(_pulldown);

                if (_registeredStage)
                {
                    _registeredStage.removeEventListener("resize", onStageResized);
                };

                _rootDisplayObject.removeChild(_pulldownDisplayObject);
                _rootDisplayObject.removeChild(_flowViewerDisplayObject);
                _rootDisplayObject.removeEventListener("addedToStage", onAddedToStage);
                _rootDisplayObject = null;
                _pulldownDisplayObject = null;
                _flowViewerDisplayObject = null;
            };
        }

        public function get disposed():Boolean
        {
            return (_rootDisplayObject == null);
        }

        public function get rootDisplayObject():DisplayObject
        {
            return (_rootDisplayObject);
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            _registeredStage = _rootDisplayObject.stage;
            _registeredStage.addEventListener("resize", onStageResized);
            _pulldown.resize(_registeredStage.stageWidth, _registeredStage.stageHeight);
            _component.registerUpdateReceiver(_pulldown, 200);
        }

        private function onStageResized(_arg_1:Event):void
        {
            _pulldown.resize(_registeredStage.stageWidth, _registeredStage.stageHeight);
            _flowViewer.resize(_registeredStage.stageWidth, _registeredStage.stageHeight);
        }

    }
}
