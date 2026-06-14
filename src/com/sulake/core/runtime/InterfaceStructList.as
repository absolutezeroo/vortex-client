package com.sulake.core.runtime
{
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.getQualifiedClassName;
    import com.sulake.core.runtime.IID;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.runtime.*;

    internal final class InterfaceStructList implements IDisposable 
    {

        private var _list:Array = [];

        public function get length():uint
        {
            return (_list.length);
        }

        public function get disposed():Boolean
        {
            return (_list == null);
        }

        public function dispose():void
        {
            var _local_1:InterfaceStruct;
            var _local_3:uint;
            var _local_2:uint = _list.length;
            _local_3 = 0;

            while (_local_3 < _local_2)
            {
                _local_1 = _list.pop();
                _local_1.dispose();
                _local_3++;
            };

            _list = null;
        }

        public function insert(interfaceStruct:InterfaceStruct):uint
        {
            _list.push(interfaceStruct);
            return (_list.length);
        }

        public function remove(index:uint):InterfaceStruct
        {
            var _local_2:InterfaceStruct;

            if (index < _list.length)
            {
                _local_2 = _list[index];
                _list.splice(index, 1);
                return (_local_2);
            };

            throw (new Error("Index out of range!"));
        }

        public function find(iid:IID):IUnknown
        {
            var _local_2:InterfaceStruct;
            var _local_5:uint;
            var _local_3:String = getQualifiedClassName(iid);
            var _local_4:uint = _list.length;
            _local_5 = 0;

            while (_local_5 < _local_4)
            {
                _local_2 = (_list[_local_5] as InterfaceStruct);

                if (_local_2.iis == _local_3)
                {
                    return (_local_2.unknown);
                };

                _local_5++;
            };

            return (null);
        }

        public function getStructByInterface(iid:IID):InterfaceStruct
        {
            var _local_2:InterfaceStruct;
            var _local_5:uint;
            var _local_3:String = getQualifiedClassName(iid);
            var _local_4:uint = _list.length;
            _local_5 = 0;

            while (_local_5 < _local_4)
            {
                _local_2 = (_list[_local_5] as InterfaceStruct);

                if (_local_2.iis == _local_3)
                {
                    return (_local_2);
                };

                _local_5++;
            };

            return (null);
        }

        public function getIndexByInterface(iid:IID):int
        {
            var _local_2:InterfaceStruct;
            var _local_5:int;
            var _local_3:String = getQualifiedClassName(iid);
            var _local_4:uint = _list.length;
            _local_5 = 0;

            while (_local_5 < _local_4)
            {
                _local_2 = (_list[_local_5] as InterfaceStruct);

                if (_local_2.iis == _local_3)
                {
                    return (_local_5);
                };

                _local_5++;
            };

            return (-1);
        }

        public function mapStructsByInterface(iid:IID, out:Array):uint
        {
            var _local_3:InterfaceStruct;
            var _local_7:uint;
            var _local_4:String = getQualifiedClassName(iid);
            var _local_5:uint;
            var _local_6:uint = _list.length;
            _local_7 = 0;

            while (_local_7 < _local_6)
            {
                _local_3 = (_list[_local_7] as InterfaceStruct);

                if (_local_3.iis == _local_4)
                {
                    out.push(_local_3);
                    _local_5++;
                };

                _local_7++;
            };

            return (_local_5);
        }

        public function getStructByImplementor(unknown:IUnknown):InterfaceStruct
        {
            var _local_2:InterfaceStruct;
            var _local_4:uint;
            var _local_3:uint = _list.length;
            _local_4 = 0;

            while (_local_4 < _local_3)
            {
                _local_2 = (_list[_local_4] as InterfaceStruct);

                if (_local_2.unknown == unknown)
                {
                    return (_local_2);
                };

                _local_4++;
            };

            return (null);
        }

        public function getIndexByImplementor(unknown:IUnknown):int
        {
            var _local_2:InterfaceStruct;
            var _local_4:uint;
            var _local_3:uint = _list.length;
            _local_4 = 0;

            while (_local_4 < _local_3)
            {
                _local_2 = (_list[_local_4] as InterfaceStruct);

                if (_local_2.unknown == unknown)
                {
                    return (_local_4);
                };

                _local_4++;
            };

            return (-1);
        }

        public function mapStructsByImplementor(unknown:IUnknown, out:Array):uint
        {
            var _local_3:InterfaceStruct;
            var _local_6:uint;
            var _local_5:uint;
            var _local_4:uint = _list.length;
            _local_6 = 0;

            while (_local_6 < _local_4)
            {
                _local_3 = (_list[_local_6] as InterfaceStruct);

                if (_local_3.unknown == unknown)
                {
                    out.push(_local_3);
                    _local_5++;
                };

                _local_6++;
            };

            return (_local_5);
        }

        public function getStructByIndex(index:uint):InterfaceStruct
        {
            return ((index < _list.length) ? _list[index] : null);
        }

        public function getTotalReferenceCount():uint
        {
            var _local_1:InterfaceStruct;
            var _local_4:uint;
            var _local_3:uint;
            var _local_2:uint = _list.length;
            _local_4 = 0;

            while (_local_4 < _local_2)
            {
                _local_1 = (_list[_local_4] as InterfaceStruct);
                _local_3 = (_local_3 + _local_1.references);
                _local_4++;
            };

            return (_local_3);
        }

    }
}
