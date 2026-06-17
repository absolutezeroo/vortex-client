package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.messages.RoomObjectMoveUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.data.LegacyStuffData;

    public class FurniturePushableLogic extends FurnitureMultiStateLogic
    {

        private static const ANIMATION_NOT_MOVING:int = 0;
        private static const ANIMATION_MOVING:int = 1;
        private static const MAX_ANIMATION_COUNT:int = 10;

        private var _oldLocation:Vector3d = null;

        public function FurniturePushableLogic()
        {
            moveUpdateInterval = 500;
            _oldLocation = new Vector3d();
        }

        override public function processUpdateMessage(updateMessage:RoomObjectUpdateMessage):void
        {
            var currentLocation:IVector3d;
            var locationDelta:IVector3d;
            var targetLocation:IVector3d;

            if (updateMessage == null)
            {
                return;
            };

            var moveUpdateMessage:RoomObjectMoveUpdateMessage = (updateMessage as RoomObjectMoveUpdateMessage);

            if (((!(object == null)) && (moveUpdateMessage == null)))
            {
                if (updateMessage.loc != null)
                {
                    currentLocation = object.getLocation();
                    locationDelta = Vector3d.dif(updateMessage.loc, currentLocation);

                    if (locationDelta != null)
                    {
                        if (((Math.abs(locationDelta.x) < 2) && (Math.abs(locationDelta.y) < 2)))
                        {
                            targetLocation = currentLocation;

                            if (((Math.abs(locationDelta.x) > 1) || (Math.abs(locationDelta.y) > 1)))
                            {
                                targetLocation = Vector3d.sum(currentLocation, Vector3d.product(locationDelta, 0.5));
                            };

                            moveUpdateMessage = new RoomObjectMoveUpdateMessage(targetLocation, updateMessage.loc, updateMessage.dir);
                            super.processUpdateMessage(moveUpdateMessage);
                            return;
                        };
                    };
                };
            };

            if (((!(updateMessage.loc == null)) && (moveUpdateMessage == null)))
            {
                moveUpdateMessage = new RoomObjectMoveUpdateMessage(updateMessage.loc, updateMessage.loc, updateMessage.dir);
                super.processUpdateMessage(moveUpdateMessage);
            };

            var dataUpdateMessage:RoomObjectDataUpdateMessage = (updateMessage as RoomObjectDataUpdateMessage);

            if (dataUpdateMessage != null)
            {
                if (dataUpdateMessage.state > 0)
                {
                    moveUpdateInterval = (500 / getUpdateIntervalValue(dataUpdateMessage.state));
                }

                else
                {
                    moveUpdateInterval = 1;
                };

                handleDataUpdateMessage(dataUpdateMessage);
                return;
            };

            if (((moveUpdateMessage) && (moveUpdateMessage.isSlideUpdate)))
            {
                moveUpdateInterval = 500;
            };

            super.processUpdateMessage(updateMessage);
        }

        protected function getUpdateIntervalValue(state:int):int
        {
            return (state / 10);
        }

        protected function getAnimationValue(state:int):int
        {
            return (state % 10);
        }

        private function handleDataUpdateMessage(dataUpdateMessage:RoomObjectDataUpdateMessage):void
        {
            var legacyStuffData:LegacyStuffData;
            var animationValue:int = getAnimationValue(dataUpdateMessage.state);

            if (animationValue != dataUpdateMessage.state)
            {
                legacyStuffData = new LegacyStuffData();
                legacyStuffData.setString(String(animationValue));
                dataUpdateMessage = new RoomObjectDataUpdateMessage(animationValue, legacyStuffData, dataUpdateMessage.extra);
            };

            super.processUpdateMessage(dataUpdateMessage);
        }

        override public function update(time:int):void
        {
            if (object != null)
            {
                _oldLocation.assign(object.getLocation());
                super.update(time);

                if (Vector3d.dif(object.getLocation(), _oldLocation).length == 0)
                {
                    if (object.getState(0) != 0)
                    {
                        object.setState(0, 0);
                    };
                };
            };
        }

    }
}
