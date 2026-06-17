package com.sulake.habbo.room.object
{
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.XmlUtil;
    import com.sulake.room.utils.IVector3d;

    public class RoomPlaneBitmapMaskParser 
    {

        private var _masks:Map = null;

        public function RoomPlaneBitmapMaskParser()
        {
            _masks = new Map();
        }

        public function get maskCount():int
        {
            return (_masks.length);
        }

        public function dispose():void
        {
            if (_masks != null)
            {
                reset();
                _masks.dispose();
                _masks = null;
            };
        }

        public function initialize(xml:XML):Boolean
        {
            var index:int;
            var maskNode:XML;
            var maskId:String;
            var maskType:String;
            var location:Vector3d;
            var maskCategory:String;
            var locationList:XMLList;
            var locationNode:XML;
            var mask:RoomPlaneBitmapMaskData;

            if (xml == null)
            {
                return (false);
            };

            _masks.reset();

            var requiredMaskAttributes:Array = ["id", "type", "category"];
            var requiredLocationAttributes:Array = ["x", "y", "z"];
            var unusedLocationList:XMLList;
            var maskNodes:XMLList = xml.planeMask;
            index = 0;

            while (index < maskNodes.length())
            {
                maskNode = maskNodes[index];

                if (!XmlUtil.checkRequiredAttributes(maskNode, requiredMaskAttributes))
                {
                    return (false);
                };

                maskId = maskNode.@id;
                maskType = maskNode.@type;
                location = null;
                maskCategory = maskNode.@category;
                locationList = maskNode.location;

                if (locationList.length() != 1)
                {
                    return (false);
                };

                locationNode = locationList[0];

                if (!XmlUtil.checkRequiredAttributes(locationNode, requiredLocationAttributes))
                {
                    return (false);
                };

                location = new Vector3d(Number(locationNode.@x), Number(locationNode.@y), Number(locationNode.@z));
                mask = new RoomPlaneBitmapMaskData(maskType, location, maskCategory);
                _masks.add(maskId, mask);
                index++;
            };

            return (true);
        }

        public function reset():void
        {
            var index:int;
            var mask:RoomPlaneBitmapMaskData;
            index = 0;

            while (index < _masks.length)
            {
                mask = (_masks.getWithIndex(index) as RoomPlaneBitmapMaskData);

                if (mask != null)
                {
                    mask.dispose();
                };

                index++;
            };

            _masks.reset();
        }

        public function addMask(id:String, type:String, loc:IVector3d, category:String):void
        {
            var mask:RoomPlaneBitmapMaskData = new RoomPlaneBitmapMaskData(type, loc, category);
            _masks.remove(id);
            _masks.add(id, mask);
        }

        public function removeMask(id:String):Boolean
        {
            var mask:RoomPlaneBitmapMaskData = (_masks.remove(id) as RoomPlaneBitmapMaskData);

            if (mask != null)
            {
                mask.dispose();
                return (true);
            };

            return (false);
        }

        public function getXML():XML
        {
            var index:int;
            var maskType:String;
            var maskCategory:String;
            var maskXml:XML;
            var location:IVector3d;
            var rootXml:XML = <planeMasks/>

            ;
            index = 0;

            while (index < maskCount)
            {
                maskType = getMaskType(index);
                maskCategory = getMaskCategory(index);
                maskXml = new XML((((((("<planeMask id=" + (('"' + index) + '"')) + " type=") + (('"' + maskType) + '"')) + " category=") + (('"' + maskCategory) + '"')) + "/>\r\n\t\t\t\t"));
                location = getMaskLocation(index);

                if (location != null)
                {
                    maskXml.appendChild(new XML((((((("<location x=" + (('"' + location.x) + '"')) + " y=") + (('"' + location.y) + '"')) + " z=") + (('"' + location.z) + '"')) + "/> ")));
                    rootXml.appendChild(maskXml);
                };

                index++;
            };

            return (rootXml);
        }

        public function getMaskLocation(index:int):IVector3d
        {
            if (((index < 0) || (index >= maskCount)))
            {
                return (null);
            };

            var mask:RoomPlaneBitmapMaskData = (_masks.getWithIndex(index) as RoomPlaneBitmapMaskData);

            if (mask != null)
            {
                return (mask.loc);
            };

            return (null);
        }

        public function getMaskType(index:int):String
        {
            if (((index < 0) || (index >= maskCount)))
            {
                return (null);
            };

            var mask:RoomPlaneBitmapMaskData = (_masks.getWithIndex(index) as RoomPlaneBitmapMaskData);

            if (mask != null)
            {
                return (mask.type);
            };

            return (null);
        }

        public function getMaskCategory(index:int):String
        {
            if (((index < 0) || (index >= maskCount)))
            {
                return (null);
            };

            var mask:RoomPlaneBitmapMaskData = (_masks.getWithIndex(index) as RoomPlaneBitmapMaskData);

            if (mask != null)
            {
                return (mask.category);
            };

            return (null);
        }

    }
}

