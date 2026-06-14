package com.sulake.core.window.iterators
{
    import flash.utils.Proxy;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.IWindow;
    import flash.utils.flash_proxy; 

    use namespace flash.utils.flash_proxy;

    public class ContainerIterator extends Proxy implements IIterator 
    {

        private var _iterable:WindowController;

        public function ContainerIterator(_arg_1:WindowController)
        {
            _iterable = _arg_1;
        }

        public function get length():uint
        {
            return (_iterable.numChildren);
        }

        public function indexOf(_arg_1:*):int
        {
            return (_iterable.getChildIndex(_arg_1));
        }

        override flash_proxy function getProperty(_arg_1:*):*
        {
            return (_iterable.getChildAt(uint(_arg_1)));
        }

        override flash_proxy function setProperty(_arg_1:*, _arg_2:*):void
        {
            var _local_3:IWindow;
            _local_3 = (_arg_2 as IWindow);

            var _local_4:int = _iterable.getChildIndex(_local_3);

            if (_local_4 == _arg_1)
            {
                return;
            };

            if (_local_4 > -1)
            {
                _iterable.removeChild(_local_3);
            };

            _iterable.addChildAt(_local_3, _arg_1);
        }

        override flash_proxy function nextNameIndex(_arg_1:int):int
        {
            return ((_arg_1 < _iterable.numChildren) ? (_arg_1 + 1) : 0);
        }

        override flash_proxy function nextValue(_arg_1:int):*
        {
            return (_iterable.getChildAt((_arg_1 - 1)));
        }

    }
}
