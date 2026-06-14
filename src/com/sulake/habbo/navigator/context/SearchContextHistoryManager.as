package com.sulake.habbo.navigator.context
{
    import __AS3__.vec.Vector;
    import com.sulake.habbo.navigator.HabboNewNavigator;

    public class SearchContextHistoryManager 
    {

        private var _contextHistory:Vector.<SearchContext> = new Vector.<SearchContext>(0);
        private var _browsingOffset:int = -1;

        public function SearchContextHistoryManager(_arg_1:HabboNewNavigator)
        {
        }

        public function addSearchContextAtCurrentOffset(_arg_1:SearchContext):int
        {
            if (_contextHistory.length > (_browsingOffset + 1))
            {
                _contextHistory.splice((_browsingOffset + 1), (_contextHistory.length - _browsingOffset));
            };

            _contextHistory.push(_arg_1);
            return (++_browsingOffset);
        }

        public function getPreviousSearchContextAndGoBack():SearchContext
        {
            if (hasPrevious)
            {
                return (_contextHistory[--_browsingOffset]);
            };

            return (null);
        }

        public function getNextSearchContextAndMoveForward():SearchContext
        {
            if (hasNext)
            {
                return (_contextHistory[++_browsingOffset]);
            };

            return (null);
        }

        public function get hasNext():Boolean
        {
            return ((_browsingOffset + 1) < _contextHistory.length);
        }

        public function get hasPrevious():Boolean
        {
            return ((_browsingOffset > 0) && (_contextHistory.length > 0));
        }

        public function toString():String
        {
            var _local_1:int;
            var _local_2:String = "history: [";
            _local_1 = 0;

            while (_local_1 < _contextHistory.length)
            {
                _local_2 = (_local_2 + _contextHistory[_local_1].toString());

                if (_local_1 < (_contextHistory.length - 1))
                {
                    _local_2 = (_local_2 + ",");
                };

                _local_1++;
            };

            return ((_local_2 + "] browsing offset: ") + _browsingOffset);
        }

    }
}
