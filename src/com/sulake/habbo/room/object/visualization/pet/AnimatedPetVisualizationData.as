package com.sulake.habbo.room.object.visualization.pet
{
    import com.sulake.habbo.room.object.visualization.furniture.AnimatedFurnitureVisualizationData;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.object.visualization.data.SizeData;
    import com.sulake.habbo.room.object.visualization.data.AnimationSizeData;

    public class AnimatedPetVisualizationData extends AnimatedFurnitureVisualizationData 
    {

        private var _commonAssets:IAssetLibrary = null;
        private var _isAllowedToTurnHead:Boolean = true;

        public function set commonAssets(value:IAssetLibrary):void
        {
            _commonAssets = value;
        }

        public function get commonAssets():IAssetLibrary
        {
            return (_commonAssets);
        }

        override protected function defineVisualizations(data:XML):Boolean
        {
            _isAllowedToTurnHead = ((data.graphics.hasOwnProperty("@disableheadturn")) ? (!(data.graphics.@disableheadturn == "1")) : true);
            return (super.defineVisualizations(data));
        }

        override protected function createSizeData(visualizationType:int, size:int, scale:int):SizeData
        {
            var sizeData:SizeData;

            if (visualizationType > 1)
            {
                sizeData = new PetAnimationSizeData(size, scale);
            }

            else
            {
                sizeData = new AnimationSizeData(size, scale);
            };

            return (sizeData);
        }

        override protected function processVisualizationElement(sizeData:SizeData, data:XML):Boolean
        {
            var petSizeData:PetAnimationSizeData;

            if (((sizeData == null) || (data == null)))
            {
                return (false);
            };

            switch (String(data.name()))
            {
                case "postures":
                    petSizeData = (sizeData as PetAnimationSizeData);

                    if (petSizeData != null)
                    {
                        if (!petSizeData.definePostures(data))
                        {
                            return (false);
                        };
                    };

                    break;
                case "gestures":
                    petSizeData = (sizeData as PetAnimationSizeData);

                    if (petSizeData != null)
                    {
                        if (!petSizeData.defineGestures(data))
                        {
                            return (false);
                        };
                    };

                    break;
                default:

                    if (!super.processVisualizationElement(sizeData, data))
                    {
                        return (false);
                    };
            };

            return (true);
        }

        public function getAnimationForPosture(size:int, posture:String):int
        {
            var petSizeData:PetAnimationSizeData = (getSizeData(size) as PetAnimationSizeData);

            if (petSizeData != null)
            {
                return (petSizeData.getAnimationForPosture(posture));
            };

            return (-1);
        }

        public function getGestureDisabled(size:int, gesture:String):Boolean
        {
            var petSizeData:PetAnimationSizeData = (getSizeData(size) as PetAnimationSizeData);

            if (petSizeData != null)
            {
                return (petSizeData.getGestureDisabled(gesture));
            };

            return (false);
        }

        public function getAnimationForGesture(size:int, gesture:String):int
        {
            var petSizeData:PetAnimationSizeData = (getSizeData(size) as PetAnimationSizeData);

            if (petSizeData != null)
            {
                return (petSizeData.getAnimationForGesture(gesture));
            };

            return (-1);
        }

        public function getPostureForAnimation(size:int, animationId:int, useDefault:Boolean):String
        {
            var petSizeData:PetAnimationSizeData = (getSizeData(size) as PetAnimationSizeData);

            if (petSizeData != null)
            {
                return (petSizeData.getPostureForAnimation(animationId, useDefault));
            };

            return (null);
        }

        public function getGestureForAnimation(size:int, animationId:int):String
        {
            var petSizeData:PetAnimationSizeData = (getSizeData(size) as PetAnimationSizeData);

            if (petSizeData != null)
            {
                return (petSizeData.getGestureForAnimation(animationId));
            };

            return (null);
        }

        public function getGestureForAnimationId(size:int, animationId:int):String
        {
            var petSizeData:PetAnimationSizeData = (getSizeData(size) as PetAnimationSizeData);
            return ((petSizeData == null) ? null : petSizeData.getGestureForAnimationId(animationId));
        }

        public function getPostureCount(size:int):int
        {
            var petSizeData:PetAnimationSizeData = (getSizeData(size) as PetAnimationSizeData);

            if (petSizeData != null)
            {
                return (petSizeData.getPostureCount());
            };

            return (0);
        }

        public function getGestureCount(size:int):int
        {
            var petSizeData:PetAnimationSizeData = (getSizeData(size) as PetAnimationSizeData);

            if (petSizeData != null)
            {
                return (petSizeData.getGestureCount());
            };

            return (0);
        }

        public function get isAllowedToTurnHead():Boolean
        {
            return (_isAllowedToTurnHead);
        }

    }
}