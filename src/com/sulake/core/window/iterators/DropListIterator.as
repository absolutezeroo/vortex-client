package com.sulake.core.window.iterators
{
    import flash.utils.Proxy;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.DropListController;
    import com.sulake.core.window.IWindow;
    import flash.utils.flash_proxy; 

    use namespace flash.utils.flash_proxy;

    public class DropListIterator extends Proxy implements IIterator 
    {

        private var _iterable:DropListController;

        public function DropListIterator(_arg_1:DropListController)
        {
            _iterable = _arg_1;
        }

        public function get length():uint
        {
            return (_iterable.numMenuItems);
        }

        public function indexOf(_arg_1:*):int
        {
            return (_iterable.getMenuItemIndex(_arg_1));
        }

        override flash_proxy function getProperty(_arg_1:*):*
        {
            return (_iterable.getMenuItemAt(uint(_arg_1)));
        }

        override flash_proxy function setProperty(_arg_1:*, _arg_2:*):void
        {
            var _local_3:IWindow;
            _local_3 = (_arg_2 as IWindow);

            var _local_4:int = _iterable.getMenuItemIndex(_local_3);

            if (_local_4 == _arg_1)
            {
                return;
            };

            if (_local_4 > -1)
            {
                _iterable.removeMenuItem(_local_3);
            };

            _iterable.addMenuItemAt(_local_3, _arg_1);
        }

        override flash_proxy function nextNameIndex(_arg_1:int):int
        {
            return ((_arg_1 < _iterable.numMenuItems) ? (_arg_1 + 1) : 0);
        }

        override flash_proxy function nextValue(_arg_1:int):*
        {
            return (_iterable.getMenuItemAt((_arg_1 - 1)));
        }

    }
}
