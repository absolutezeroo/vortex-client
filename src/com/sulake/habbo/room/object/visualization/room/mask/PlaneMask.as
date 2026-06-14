package com.sulake.habbo.room.object.visualization.room.mask
{
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.utils.IVector3d;

    public class PlaneMask 
    {

        private var _maskVisualizations:Map;
        private var _sizes:Array = [];
        private var _assetNames:Map;
        private var _lastMaskVisualization:PlaneMaskVisualization = null;
        private var _lastSize:int = -1;

        public function PlaneMask()
        {
            _maskVisualizations = new Map();
            _assetNames = new Map();
        }

        public function dispose():void
        {
            var _local_2:PlaneMaskVisualization;
            var _local_1:int;

            if (_maskVisualizations != null)
            {
                _local_2 = null;
                _local_1 = 0;

                while (_local_1 < _maskVisualizations.length)
                {
                    _local_2 = (_maskVisualizations.getWithIndex(_local_1) as PlaneMaskVisualization);

                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    };

                    _local_1++;
                };

                _maskVisualizations.dispose();
                _maskVisualizations = null;
            };

            _lastMaskVisualization = null;
            _sizes = null;
        }

        public function createMaskVisualization(_arg_1:int):PlaneMaskVisualization
        {
            if (_maskVisualizations.getValue(String(_arg_1)) != null)
            {
                return (null);
            };

            var _local_2:PlaneMaskVisualization = new PlaneMaskVisualization();
            _maskVisualizations.add(String(_arg_1), _local_2);
            _sizes.push(_arg_1);
            _sizes.sort();
            return (_local_2);
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

        protected function getMaskVisualization(_arg_1:int):PlaneMaskVisualization
        {
            if (_arg_1 == _lastSize)
            {
                return (_lastMaskVisualization);
            };

            var _local_2:int = getSizeIndex(_arg_1);

            if (_local_2 < _sizes.length)
            {
                _lastMaskVisualization = (_maskVisualizations.getValue(_sizes[_local_2]) as PlaneMaskVisualization);
            }

            else
            {
                _lastMaskVisualization = null;
            };

            _lastSize = _arg_1;
            return (_lastMaskVisualization);
        }

        public function getGraphicAsset(_arg_1:Number, _arg_2:IVector3d):IGraphicAsset
        {
            var _local_3:PlaneMaskVisualization = getMaskVisualization(_arg_1);

            if (_local_3 == null)
            {
                return (null);
            };

            var _local_4:IGraphicAsset = _local_3.getAsset(_arg_2);
            return (_local_4);
        }

        public function getAssetName(_arg_1:int):String
        {
            return (_assetNames.getValue(_arg_1));
        }

        public function setAssetName(_arg_1:int, _arg_2:String):void
        {
            _assetNames.add(_arg_1, _arg_2);
        }

    }
}
