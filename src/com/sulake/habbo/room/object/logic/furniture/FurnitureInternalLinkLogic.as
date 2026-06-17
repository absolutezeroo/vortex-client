package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

    public class FurnitureInternalLinkLogic extends FurnitureLogic 
    {

        private var _showStateOneOnceRendered:Boolean = false;
        private var _updateCount:int = 0;

        override public function initialize(_arg_xml:XML):void
        {
            super.initialize(_arg_xml);

            if (_arg_xml == null)
            {
                return;
            };

            var actionList:XMLList = _arg_xml.action;

            if (actionList.length() != 0)
            {
                object.getModelController().setString("furniture_internal_link", actionList.@link);

                if (actionList.@startState == "1")
                {
                    _showStateOneOnceRendered = true;
                };
            };
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

        override public function update(_arg_time:int):void
        {
            super.update(_arg_time);

            if (!_showStateOneOnceRendered)
            {
                return;
            };

            _updateCount++;

            if (((_showStateOneOnceRendered) && (_updateCount == 20)))
            {
                setAnimationState(1);
            };
        }

        public function setAnimationState(_arg_state:int):void
        {
            if (object == null)
            {
                return;
            };

            var modelController:IRoomObjectModelController = object.getModelController();

            if (modelController != null)
            {
                modelController.setNumber("furniture_automatic_state_index", _arg_state, false);
            };
        }

        override public function mouseEvent(_arg_mouseEvent:RoomSpriteMouseEvent, _arg_geometry:IRoomGeometry):void
        {
            if (_arg_mouseEvent == null)
            {
                return;
            };

            if (((_arg_mouseEvent.type == "doubleClick") && (_showStateOneOnceRendered)))
            {
                setAnimationState(0);
            };

            super.mouseEvent(_arg_mouseEvent, _arg_geometry);
        }

    }
}
