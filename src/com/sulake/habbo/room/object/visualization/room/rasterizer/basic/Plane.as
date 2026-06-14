package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.IRoomGeometry;

    public class Plane 
    {

        private var _planeVisualizations:Map;
        private var _sizes:Array = [];
        private var _lastPlaneVisualization:PlaneVisualization = null;
        private var _lastSize:int = -1;

        public function Plane()
        {
            _planeVisualizations = new Map();
        }

        public function isStatic(_arg_1:int):Boolean
        {
            return (true);
        }

        public function dispose():void
        {
            var _local_1:PlaneVisualization;
            var _local_2:int;

            if (_planeVisualizations != null)
            {
                _local_1 = null;
                _local_2 = 0;

                while (_local_2 < _planeVisualizations.length)
                {
                    _local_1 = (_planeVisualizations.getWithIndex(_local_2) as PlaneVisualization);

                    if (_local_1 != null)
                    {
                        _local_1.dispose();
                    };

                    _local_2++;
                };

                _planeVisualizations.dispose();
                _planeVisualizations = null;
            };

            _lastPlaneVisualization = null;
            _sizes = null;
        }

        public function clearCache():void
        {
            var _local_2:int;
            var _local_1:PlaneVisualization;
            _local_2 = 0;

            while (_local_2 < _planeVisualizations.length)
            {
                _local_1 = (_planeVisualizations.getWithIndex(_local_2) as PlaneVisualization);

                if (_local_1 != null)
                {
                    _local_1.clearCache();
                };

                _local_2++;
            };
        }

        public function createPlaneVisualization(_arg_1:int, _arg_2:int, _arg_3:IRoomGeometry):PlaneVisualization
        {
            if (_planeVisualizations.getValue(String(_arg_1)) != null)
            {
                return (null);
            };

            var _local_4:PlaneVisualization = new PlaneVisualization(_arg_1, _arg_2, _arg_3);
            _planeVisualizations.add(String(_arg_1), _local_4);
            _sizes.push(_arg_1);
            _sizes.sort();
            return (_local_4);
        }

        private function getSizeIndex(_arg_1:int):int
        {
            var _local_3:int;
            var _local_2:int;
            _local_3 = 1;

            while (_local_3 < _sizes.length)
            {
                if (_sizes[_local_3] > _arg_1)
                {
                    if ((_sizes[_local_3] - _arg_1) < (_arg_1 - _sizes[(_local_3 - 1)]))
                    {
                        _local_2 = _local_3;
                    };

                    break;
                };

                _local_2 = _local_3;
                _local_3++;
            };

            return (_local_2);
        }

        protected function getPlaneVisualization(_arg_1:int):PlaneVisualization
        {
            if (_arg_1 == _lastSize)
            {
                return (_lastPlaneVisualization);
            };

            var _local_2:int = getSizeIndex(_arg_1);

            if (_local_2 < _sizes.length)
            {
                _lastPlaneVisualization = (_planeVisualizations.getValue(_sizes[_local_2]) as PlaneVisualization);
            }

            else
            {
                _lastPlaneVisualization = null;
            };

            _lastSize = _arg_1;
            return (_lastPlaneVisualization);
        }

        public function getLayers():Array
        {
            return (getPlaneVisualization(_lastSize).getLayers());
        }

    }
}
