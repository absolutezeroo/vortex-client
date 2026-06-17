package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.events.RoomToObjectOwnAvatarMoveEvent;

    public class FurnitureChangeStateWhenStepOnLogic extends FurnitureLogic 
    {

        override public function initialize(_model:XML):void
        {
            super.initialize(_model);
            eventDispatcher.addEventListener("ROAME_MOVE_TO", onOwnAvatarMove);
        }

        override public function tearDown():void
        {
            eventDispatcher.removeEventListener("ROAME_MOVE_TO", onOwnAvatarMove);
            super.tearDown();
        }

        private function onOwnAvatarMove(_moveEvent:RoomToObjectOwnAvatarMoveEvent):void
        {
            var _sizeX:int;
            var _sizeY:int;
            var _direction:IVector3d;
            var _swap:int;
            var _directionIndex:int;

            if (object == null)
            {
                return;
            };

            var _location:IVector3d = object.getLocation();

            if (_moveEvent.targetLoc)
            {
                _sizeX = object.getModel().getNumber("furniture_size_x");
                _sizeY = object.getModel().getNumber("furniture_size_y");
                _direction = object.getDirection();
                _swap = 0;
                _directionIndex = int((((_direction.x + 45) % 360) / 90));

                if (((_directionIndex == 1) || (_directionIndex == 3)))
                {
                    _swap = _sizeX;
                    _sizeX = _sizeY;
                    _sizeY = _swap;
                };

                if ((((_moveEvent.targetLoc.x >= _location.x) && (_moveEvent.targetLoc.x < (_location.x + _sizeX))) && ((_moveEvent.targetLoc.y >= _location.y) && (_moveEvent.targetLoc.y < (_location.y + _sizeY)))))
                {
                    object.setState(1, 0);
                }

                else
                {
                    object.setState(0, 0);
                };
            };
        }

    }
}