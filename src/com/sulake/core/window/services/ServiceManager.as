package com.sulake.core.window.services
{
    import com.sulake.core.runtime.IDisposable;
    import flash.display.DisplayObject;
    import com.sulake.core.window.IWindowContext;

    public class ServiceManager implements IInternalWindowServices, IDisposable 
    {

        private var _rid:uint;
        private var _root:DisplayObject;
        private var _disposed:Boolean = false;
        private var _windowContext:IWindowContext;
        private var _windowMouseDragger:IMouseDraggingService;
        private var _windowMouseScaler:IMouseScalingService;
        private var _windowMouseListener:IMouseListenerService;
        private var _windowFocusManager:IFocusManagerService;
        private var _windowToolTipAgent:IToolTipAgentService;
        private var _windowGestureAgent:IGestureAgentService;

        public function ServiceManager(_arg_1:IWindowContext, _arg_2:DisplayObject)
        {
            _rid = 0;
            _root = _arg_2;
            _windowContext = _arg_1;
            _windowMouseDragger = new WindowMouseDragger(_arg_2);
            _windowMouseScaler = new WindowMouseScaler(_arg_2);
            _windowMouseListener = new WindowMouseListener(_arg_2);
            _windowFocusManager = new FocusManager(_arg_2);
            _windowToolTipAgent = new WindowToolTipAgent(_arg_2);
            _windowGestureAgent = new GestureAgentService();
        }

        public function dispose():void
        {
            if (_windowMouseDragger != null)
            {
                _windowMouseDragger.dispose();
                _windowMouseDragger = null;
            };

            if (_windowMouseScaler != null)
            {
                _windowMouseScaler.dispose();
                _windowMouseScaler = null;
            };

            if (_windowMouseListener != null)
            {
                _windowMouseListener.dispose();
                _windowMouseListener = null;
            };

            if (_windowFocusManager != null)
            {
                _windowFocusManager.dispose();
                _windowFocusManager = null;
            };

            if (_windowToolTipAgent != null)
            {
                _windowToolTipAgent.dispose();
                _windowToolTipAgent = null;
            };

            if (_windowGestureAgent != null)
            {
                _windowGestureAgent.dispose();
                _windowGestureAgent = null;
            };

            _root = null;
            _windowContext = null;
            _disposed = true;
        }

        public function getMouseDraggingService():IMouseDraggingService
        {
            return (_windowMouseDragger);
        }

        public function getMouseScalingService():IMouseScalingService
        {
            return (_windowMouseScaler);
        }

        public function getMouseListenerService():IMouseListenerService
        {
            return (_windowMouseListener);
        }

        public function getFocusManagerService():IFocusManagerService
        {
            return (_windowFocusManager);
        }

        public function getToolTipAgentService():IToolTipAgentService
        {
            return (_windowToolTipAgent);
        }

        public function getGestureAgentService():IGestureAgentService
        {
            return (_windowGestureAgent);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

    }
}
