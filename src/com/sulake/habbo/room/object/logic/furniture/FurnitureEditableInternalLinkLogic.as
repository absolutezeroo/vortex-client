package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

    public class FurnitureEditableInternalLinkLogic extends FurnitureLogic 
    {

        private var _showStateOneOnceRendered:Boolean = false;
        private var _updateCount:int = 0;

        override public function initialize(_model:XML):void
        {
            super.initialize(_model);

            if (_model == null)
            {
                return;
            };

            var _action:XMLList = _model.action;

            if (_action.length() != 0)
            {
                if (_action.@startState == "1")
                {
                    _showStateOneOnceRendered = true;
                };
            };
        }

        override public function update(_currentTime:int):void
        {
            super.update(_currentTime);

            if (!_showStateOneOnceRendered)
            {
                return;
            };

            _updateCount++;

            if (((_showStateOneOnceRendered) && (_updateCount > 20)))
            {
                setAnimationState(1);
                _showStateOneOnceRendered = false;
            };
        }

        public function setAnimationState(_stateIndex:int):void
        {
            if (object == null)
            {
                return;
            };

            var _modelController:IRoomObjectModelController = object.getModelController();

            if (_modelController != null)
            {
                _modelController.setNumber("furniture_automatic_state_index", _stateIndex, false);
            };
        }

        override public function mouseEvent(_mouseEvent:RoomSpriteMouseEvent, _geometry:IRoomGeometry):void
        {
            if (_mouseEvent == null)
            {
                return;
            };

            if (_mouseEvent.type == "doubleClick")
            {
                setAnimationState(0);
            };

            super.mouseEvent(_mouseEvent, _geometry);
        }

        override public function getEventTypes():Array
        {
            return (getAllEventTypes(super.getEventTypes(), ["ROWRE_INTERNAL_LINK"]));
        }

        override public function useObject():void
        {
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent("ROWRE_INTERNAL_LINK", object));
            };
        }

    }
}
