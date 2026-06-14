package com.sulake.core.window.components
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.events.WindowEvent;

    public class ActivatorController extends ContainerController 
    {

        protected var _SafeStr_883:IWindow;

        public function ActivatorController(_arg_1:String, _arg_2:uint, _arg_3:uint, _arg_4:uint, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:Function=null, _arg_9:Array=null, _arg_10:Array=null, _arg_11:uint=0)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function update(windowController:WindowController, event:WindowEvent):Boolean
        {
            if (event.type == "WE_CHILD_ACTIVATED")
            {
                setActiveChild((windowController as IWindow));
            }

            else
            {
                if (event.type == "WE_PARENT_ACTIVATED")
                {
                    return (true);
                };
            };

            return (super.update(windowController, event));
        }

        public function getActiveChild():IWindow
        {
            return (_SafeStr_883);
        }

        public function setActiveChild(window:IWindow):IWindow
        {
            if (window.parent != this)
            {
                while (true)
                {
                    window = window.parent;

                    if (window == null)
                    {
                        throw (new Error("Window passed to activator is not a child!"));
                    };

                    if (window.parent == this) break;
                };
            };

            var _local_2:IWindow = _SafeStr_883;

            if (_SafeStr_883 != window)
            {
                if (_SafeStr_883 != null)
                {
                    if (!_SafeStr_883.disposed)
                    {
                        _SafeStr_883.deactivate();
                    };
                };

                _SafeStr_883 = window;

                if (getChildIndex(window) != (numChildren - 1))
                {
                    setChildIndex(window, (numChildren - 1));
                };
            };

            return (_local_2);
        }

    }
}
