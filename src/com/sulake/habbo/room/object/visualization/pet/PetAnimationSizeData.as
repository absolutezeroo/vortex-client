package com.sulake.habbo.room.object.visualization.pet
{
    import com.sulake.habbo.room.object.visualization.data.AnimationSizeData;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.XmlUtil;
    import com.sulake.habbo.room.object.visualization.data.*;

    public class PetAnimationSizeData extends AnimationSizeData 
    {

        public static const _SafeStr_3421:int = -1;

        private var _posturesToAnimations:Map = new Map();
        private var _gesturesToAnimations:Map = new Map();
        private var _defaultPosture:String;

        public function PetAnimationSizeData(size:int, scale:int)
        {
            super(size, scale);
        }

        public function definePostures(data:XML):Boolean
        {
            var i:int;
            var postureNode:XML;
            var id:String;
            var animationId:int;

            if (data == null)
            {
                return (false);
            };

            if (XmlUtil.checkRequiredAttributes(data, ["defaultPosture"]))
            {
                _defaultPosture = data.@defaultPosture;
            }

            else
            {
                _defaultPosture = null;
            };

            var requiredAttributes:Array = ["id", "animationId"];
            var postureList:XMLList = data.posture;
            i = 0;

            while (i < postureList.length())
            {
                postureNode = postureList[i];

                if (!XmlUtil.checkRequiredAttributes(postureNode, requiredAttributes))
                {
                    return (false);
                };

                id = String(postureNode.@id);
                animationId = int(postureNode.@animationId);
                _posturesToAnimations.add(id, animationId);

                if (_defaultPosture == null)
                {
                    _defaultPosture = id;
                };

                i++;
            };

            if (_posturesToAnimations.getValue(_defaultPosture) == null)
            {
                return (false);
            };

            return (true);
        }

        public function defineGestures(data:XML):Boolean
        {
            var i:int;
            var gestureNode:XML;
            var id:String;
            var animationId:int;

            if (data == null)
            {
                return (true);
            };

            var requiredAttributes:Array = ["id", "animationId"];
            var gestureList:XMLList = data.gesture;
            i = 0;

            while (i < gestureList.length())
            {
                gestureNode = gestureList[i];

                if (!XmlUtil.checkRequiredAttributes(gestureNode, requiredAttributes))
                {
                    return (false);
                };

                id = String(gestureNode.@id);
                animationId = int(gestureNode.@animationId);
                _gesturesToAnimations.add(id, animationId);
                i++;
            };

            return (true);
        }

        public function getAnimationForPosture(posture:String):int
        {
            if (_posturesToAnimations.getValue(posture) == null)
            {
                posture = _defaultPosture;
            };

            return (_posturesToAnimations.getValue(posture));
        }

        public function getGestureDisabled(gesture:String):Boolean
        {
            if (gesture == "ded")
            {
                return (true);
            };

            return (false);
        }

        public function getAnimationForGesture(gesture:String):int
        {
            if (_gesturesToAnimations.getValue(gesture) == null)
            {
                return (-1);
            };

            return (_gesturesToAnimations.getValue(gesture));
        }

        public function getPostureForAnimation(animationId:int, useDefault:Boolean):String
        {
            if (((animationId >= 0) && (animationId < _posturesToAnimations.length)))
            {
                return (_posturesToAnimations.getKey(animationId));
            };

            return ((useDefault) ? _defaultPosture : null);
        }

        public function getGestureForAnimation(animationId:int):String
        {
            if (((animationId >= 0) && (animationId < _gesturesToAnimations.length)))
            {
                return (_gesturesToAnimations.getKey(animationId));
            };

            return (null);
        }

        public function getGestureForAnimationId(animationId:int):String
        {
            for each (var gestureKey:String in _gesturesToAnimations.getKeys())
            {
                if (_gesturesToAnimations.getValue(gestureKey) == animationId)
                {
                    return (gestureKey);
                };
            };

            return (null);
        }

        public function getPostureCount():int
        {
            return (_posturesToAnimations.length);
        }

        public function getGestureCount():int
        {
            return (_gesturesToAnimations.length);
        }

    }
}

