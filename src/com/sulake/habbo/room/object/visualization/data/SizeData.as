package com.sulake.habbo.room.object.visualization.data
{
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.XmlUtil;

    public class SizeData
    {

        public static const LAYER_LIMIT:int = 1000;
        public static const DEFAULT_DIRECTION:int = 0;

        private var _layerCount:int = 0;
        private var _angle:int = 360;
        private var _defaultDirection:DirectionData = null;
        private var _directions:Map;
        private var _colors:Map;
        private var _lastDirectionData:DirectionData = null;
        private var _lastDirection:int = -1;

        public function SizeData(layerCount:int, angle:int)
        {
            if (layerCount < 0)
            {
                layerCount = 0;
            };

            if (layerCount > 1000)
            {
                layerCount = 1000;
            };

            _layerCount = layerCount;

            if (angle < 1)
            {
                angle = 1;
            };

            if (angle > 360)
            {
                angle = 360;
            };

            _angle = angle;
            _defaultDirection = new DirectionData(layerCount);
            _directions = new Map();
            _colors = new Map();
        }

        public function dispose():void
        {
            var directionData:DirectionData;
            var colorData:ColorData;

            if (_defaultDirection != null)
            {
                _defaultDirection.dispose();
                _defaultDirection = null;
            };

            var index:int;

            if (_directions != null)
            {
                directionData = null;
                index = 0;

                while (index < _directions.length)
                {
                    directionData = (_directions.getWithIndex(index) as DirectionData);

                    if (directionData != null)
                    {
                        directionData.dispose();
                    };

                    index++;
                };

                _directions.dispose();
                _directions = null;
            };

            _lastDirectionData = null;

            if (_colors != null)
            {
                colorData = null;
                index = 0;

                while (index < _colors.length)
                {
                    colorData = (_colors.getWithIndex(index) as ColorData);

                    if (colorData != null)
                    {
                        colorData.dispose();
                    };

                    index++;
                };

                _colors.dispose();
                _colors = null;
            };
        }

        public function get layerCount():int
        {
            return (_layerCount);
        }

        public function defineLayers(xmlNode:XML):Boolean
        {
            if (xmlNode == null)
            {
                return (false);
            };

            var layerList:XMLList = xmlNode.layer;
            return (defineDirection(_defaultDirection, layerList));
        }

        public function defineDirections(xmlNode:XML):Boolean
        {
            var index:int;
            var directionXml:XML;
            var directionId:int;
            var layerList:XMLList;

            if (xmlNode == null)
            {
                return (false);
            };

            var requiredAttributes:Array = ["id"];
            var directionData:DirectionData;
            var directionList:XMLList = xmlNode.direction;
            index = 0;

            while (index < directionList.length())
            {
                directionXml = directionList[index];

                if (!XmlUtil.checkRequiredAttributes(directionXml, requiredAttributes))
                {
                    return (false);
                };

                directionId = int(directionXml.@id);
                layerList = directionXml.layer;

                if (_directions.getValue(String(directionId)) != null)
                {
                    return (false);
                };

                directionData = new DirectionData(layerCount);
                directionData.copyValues(_defaultDirection);
                defineDirection(directionData, layerList);
                _directions.add(directionId, directionData);
                _lastDirection = -1;
                _lastDirectionData = null;
                index++;
            };

            return (true);
        }

        private function defineDirection(directionData:DirectionData, layerList:XMLList):Boolean
        {
            var index:int;
            var layerXml:XML;
            var layerId:int;
            var attributeValue:String;
            var inkValue:String;
            var ignoreMouse:int;
            var zOffset:int;

            if (((directionData == null) || (layerList == null)))
            {
                return (false);
            };

            var requiredAttributes:Array = ["id"];
            index = 0;

            while (index < layerList.length())
            {
                layerXml = layerList[index];

                if (!XmlUtil.checkRequiredAttributes(layerXml, requiredAttributes))
                {
                    return (false);
                };

                layerId = int(layerXml.@id);

                if (((layerId < 0) || (layerId >= layerCount)))
                {
                    return (false);
                };

                attributeValue = layerXml.@tag;

                if (attributeValue.length > 0)
                {
                    directionData.setTag(layerId, attributeValue);
                };

                inkValue = layerXml.@ink;
                switch (inkValue)
                {
                    case "ADD":
                        directionData.setInk(layerId, 1);
                        break;
                    case "SUBTRACT":
                        directionData.setInk(layerId, 2);
                        break;
                    case "DARKEN":
                        directionData.setInk(layerId, 3);
                };

                attributeValue = layerXml.@alpha;

                if (attributeValue.length > 0)
                {
                    directionData.setAlpha(layerId, int(attributeValue));
                };

                attributeValue = layerXml.@ignoreMouse;

                if (attributeValue.length > 0)
                {
                    ignoreMouse = int(attributeValue);
                    directionData.setIgnoreMouse(layerId, (!(ignoreMouse == 0)));
                };

                attributeValue = layerXml.@x;

                if (attributeValue.length > 0)
                {
                    directionData.setXOffset(layerId, int(attributeValue));
                };

                attributeValue = layerXml.@y;

                if (attributeValue.length > 0)
                {
                    directionData.setYOffset(layerId, int(attributeValue));
                };

                attributeValue = layerXml.@z;

                if (attributeValue.length > 0)
                {
                    zOffset = int(attributeValue);
                    directionData.setZOffset(layerId, (zOffset / -1000));
                };

                index++;
            };

            return (true);
        }

        public function defineColors(xmlNode:XML):Boolean
        {
            var index:int;
            var colorXml:XML;
            var colorId:String;
            var colorLayerList:XMLList;
            var layerIndex:int;
            var colorLayerXml:XML;
            var layerId:int;
            var colorValue:int;

            if (xmlNode == null)
            {
                return (true);
            };

            var colorData:ColorData;
            var requiredColorAttributes:Array = ["id"];
            var requiredColorLayerAttributes:Array = ["id", "color"];
            var colorList:XMLList = xmlNode.color;
            index = 0;

            while (index < colorList.length())
            {
                colorXml = colorList[index];

                if (!XmlUtil.checkRequiredAttributes(colorXml, requiredColorAttributes))
                {
                    return (false);
                };

                colorId = colorXml.@id;

                if (_colors.getValue(colorId) != null)
                {
                    return (false);
                };

                colorData = new ColorData(layerCount);
                colorLayerList = colorXml.colorLayer;
                layerIndex = 0;

                while (layerIndex < colorLayerList.length())
                {
                    colorLayerXml = colorLayerList[layerIndex];

                    if (!XmlUtil.checkRequiredAttributes(colorLayerXml, requiredColorLayerAttributes))
                    {
                        colorData.dispose();
                        return (false);
                    };

                    layerId = int(colorLayerXml.@id);
                    colorValue = parseInt(colorLayerXml.@color, 16);
                    colorData.setColor(colorValue, layerId);
                    layerIndex++;
                };

                if (colorData != null)
                {
                    _colors.add(colorId, colorData);
                };

                index++;
            };

            return (true);
        }

        public function getDirectionValue(angle:int):int
        {
            var index:int;
            var keyAngle:int;
            var angleDiff:int;
            var direction:int = int((((((angle % 360) + 360) + (_angle / 2)) % 360) / _angle));

            if (_directions.getValue(String(direction)) != null)
            {
                return (direction);
            };

            direction = (((angle % 360) + 360) % 360);

            var bestDiff:int = -1;
            var bestIndex:int = -1;
            index = 0;

            while (index < _directions.length)
            {
                keyAngle = (_directions.getKey(index) * _angle);
                angleDiff = (((keyAngle - direction) + 360) % 360);

                if (angleDiff > 180)
                {
                    angleDiff = (360 - angleDiff);
                };

                if (((angleDiff < bestDiff) || (bestDiff < 0)))
                {
                    bestDiff = angleDiff;
                    bestIndex = index;
                };

                index++;
            };

            if (bestIndex >= 0)
            {
                return (_directions.getKey(bestIndex));
            };

            return (0);
        }

        private function getDirectionData(direction:int):DirectionData
        {
            if (((direction == _lastDirection) && (!(_lastDirectionData == null))))
            {
                return (_lastDirectionData);
            };

            var directionData:DirectionData;
            directionData = (_directions.getValue(String(direction)) as DirectionData);

            if (directionData == null)
            {
                directionData = _defaultDirection;
            };

            _lastDirection = direction;
            _lastDirectionData = directionData;
            return (_lastDirectionData);
        }

        public function getTag(direction:int, layerId:int):String
        {
            var directionData:DirectionData;
            directionData = getDirectionData(direction);

            if (directionData != null)
            {
                return (directionData.getTag(layerId));
            };

            return ("");
        }

        public function getInk(direction:int, layerId:int):int
        {
            var directionData:DirectionData;
            directionData = getDirectionData(direction);

            if (directionData != null)
            {
                return (directionData.getInk(layerId));
            };

            return (0);
        }

        public function getAlpha(direction:int, layerId:int):int
        {
            var directionData:DirectionData;
            directionData = getDirectionData(direction);

            if (directionData != null)
            {
                return (directionData.getAlpha(layerId));
            };

            return (0xFF);
        }

        public function getColor(direction:int, layerId:int):uint
        {
            var colorData:ColorData = (_colors.getValue(String(layerId)) as ColorData);

            if (colorData != null)
            {
                return (colorData.getColor(direction));
            };

            return (0xFFFFFF);
        }

        public function getIgnoreMouse(direction:int, layerId:int):Boolean
        {
            var directionData:DirectionData;
            directionData = getDirectionData(direction);

            if (directionData != null)
            {
                return (directionData.getIgnoreMouse(layerId));
            };

            return (false);
        }

        public function getXOffset(direction:int, layerId:int):int
        {
            var directionData:DirectionData;
            directionData = getDirectionData(direction);

            if (directionData != null)
            {
                return (directionData.getXOffset(layerId));
            };

            return (0);
        }

        public function getYOffset(direction:int, layerId:int):int
        {
            var directionData:DirectionData;
            directionData = getDirectionData(direction);

            if (directionData != null)
            {
                return (directionData.getYOffset(layerId));
            };

            return (0);
        }

        public function getZOffset(direction:int, layerId:int):Number
        {
            var directionData:DirectionData;
            directionData = getDirectionData(direction);

            if (directionData != null)
            {
                return (directionData.getZOffset(layerId));
            };

            return (0);
        }

    }
}
