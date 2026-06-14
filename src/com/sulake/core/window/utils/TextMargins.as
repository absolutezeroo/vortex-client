package com.sulake.core.window.utils
{
    import com.sulake.core.runtime.IDisposable;

    public class TextMargins implements IMargins, IDisposable 
    {

        private var _left:int;
        private var _right:int;
        private var _top:int;
        private var _bottom:int;
        private var _callback:Function;
        private var _disposed:Boolean = false;

        public function TextMargins(left:int, top:int, right:int, bottom:int, callback:Function)
        {
            _left = left;
            _top = top;
            _right = right;
            _bottom = bottom;
            _callback = ((callback != null) ? callback : nullCallback);
        }

        public function get left():int
        {
            return (_left);
        }

        public function get right():int
        {
            return (_right);
        }

        public function get top():int
        {
            return (_top);
        }

        public function get bottom():int
        {
            return (_bottom);
        }

        public function set left(left:int):void
        {
            _left = left;
            _callback(this); //not popped
        }

        public function set right(right:int):void
        {
            _right = right;
            _callback(this); //not popped
        }

        public function set top(top:int):void
        {
            _top = top;
            _callback(this); //not popped
        }

        public function set bottom(bottom:int):void
        {
            _bottom = bottom;
            _callback(this); //not popped
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get isZeroes():Boolean
        {
            return ((((_left == 0) && (_right == 0)) && (_top == 0)) && (_bottom == 0));
        }

        public function assign(left:int, top:int, right:int, bottom:int, callback:Function):void
        {
            _left = left;
            _top = top;
            _right = right;
            _bottom = bottom;
            _callback = ((callback != null) ? callback : nullCallback);
        }

        public function clone(callback:Function):TextMargins
        {
            return (new TextMargins(_left, _top, _right, _bottom, callback));
        }

        public function dispose():void
        {
            _callback = null;
            _disposed = true;
        }

        private function nullCallback(_arg_1:IMargins):void
        {
        }

    }
}