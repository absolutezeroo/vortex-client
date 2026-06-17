package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.object.logic.MovingObjectLogic;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.utils.XmlUtil;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.events.RoomObjectRoomAdEvent;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.habbo.room.events.RoomObjectStateChangeEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectHeightUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectItemDataUpdateMessage;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.messages.RoomObjectMoveUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectSelectedMessage;

    public class FurnitureLogic extends MovingObjectLogic
    {

        private static const BOUNCE_STEPS:int = 8;
        private static const BOUNCE_STEP_HEIGHT:Number = 0.0625;

        private var _mouseOver:Boolean = false;
        private var _sizeX:Number = 0;
        private var _sizeY:Number = 0;
        private var _sizeZ:Number = 0;
        private var _centerX:Number = 0;
        private var _centerY:Number = 0;
        private var _centerZ:Number = 0;
        private var _directionInitialized:Boolean = false;
        private var _bouncingStep:int = 0;
        private var _storedRotateMessage:RoomObjectUpdateMessage;
        private var _locationOffset:Vector3d = new Vector3d();
        private var _directions:Array = [];

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["RORAE_ROOM_AD_TOOLTIP_SHOW", "RORAE_ROOM_AD_TOOLTIP_HIDE", "RORAE_ROOM_AD_FURNI_DOUBLE_CLICK", "ROSCE_STATE_CHANGE", "ROE_MOUSE_CLICK", "RORAE_ROOM_AD_FURNI_CLICK", "ROE_MOUSE_DOWN"];

            if (widget != null)
            {
                eventTypes.push("ROWRE_OPEN_WIDGET");
                eventTypes.push("ROWRE_CLOSE_WIDGET");
            };

            if (contextMenu != null)
            {
                eventTypes.push("ROWRE_OPEN_FURNI_CONTEXT_MENU");
                eventTypes.push("ROWRE_CLOSE_FURNI_CONTEXT_MENU");
            };

            return (getAllEventTypes(super.getEventTypes(), eventTypes));
        }

        override public function dispose():void
        {
            super.dispose();
            _storedRotateMessage = null;
            _directions = null;
        }

        override public function set object(roomObjectController:IRoomObjectController):void
        {
            super.object = roomObjectController;

            if (((!(roomObjectController == null)) && (roomObjectController.getLocation().length > 0)))
            {
                _directionInitialized = true;
            };
        }

        override public function initialize(furnitureData:XML):void
        {
            var directionIndex:int;
            var directionXml:XML;
            var directionId:int;

            if (furnitureData == null)
            {
                return;
            };

            _sizeX = 0;
            _sizeY = 0;
            _sizeZ = 0;
            _directions = [];

            var dimensions:XMLList = furnitureData.model.dimensions;

            if (dimensions.length() == 0)
            {
                return;
            };

            var dimensionAttribute:XMLList = dimensions.@x;

            if (dimensionAttribute.length() == 1)
            {
                _sizeX = Number(dimensionAttribute);
            };

            dimensionAttribute = dimensions.@y;

            if (dimensionAttribute.length() == 1)
            {
                _sizeY = Number(dimensionAttribute);
            };

            dimensionAttribute = dimensions.@z;

            if (dimensionAttribute.length() == 1)
            {
                _sizeZ = Number(dimensionAttribute);
            };

            _centerX = (_sizeX / 2);
            _centerY = (_sizeY / 2);
            dimensionAttribute = dimensions.@centerZ;

            if (dimensionAttribute.length() == 1)
            {
                _centerZ = Number(dimensionAttribute);
            }

            else
            {
                _centerZ = (_sizeZ / 2);
            };

            var directionList:XMLList = furnitureData.model.directions.direction;
            var requiredAttributes:Array = ["id"];
            directionIndex = 0;

            while (directionIndex < directionList.length())
            {
                directionXml = directionList[directionIndex];

                if (XmlUtil.checkRequiredAttributes(directionXml, requiredAttributes))
                {
                    directionId = parseInt(directionXml.@id);
                    _directions.push(directionId);
                };

                directionIndex++;
            };

            _directions.sort(16);

            if (((object == null) || (object.getModelController() == null)))
            {
                return;
            };

            var customVarList:XMLList = furnitureData.customvars.variable;
            var customVarNames:Array = [];

            for each (var customVarXml:XML in customVarList)
            {
                customVarNames.push(customVarXml.@name.toString());
            };

            object.getModelController().setStringArray("furniture_custom_variables", customVarNames, true);
            object.getModelController().setNumber("furniture_size_x", _sizeX, true);
            object.getModelController().setNumber("furniture_size_y", _sizeY, true);

            if (!object.getModelController().hasNumber("furniture_size_z"))
            {
                object.getModelController().setNumber("furniture_size_z", _sizeZ);
            };

            object.getModelController().setNumber("furniture_center_x", _centerX, true);
            object.getModelController().setNumber("furniture_center_y", _centerY, true);
            object.getModelController().setNumber("furniture_center_z", _centerZ, true);
            object.getModelController().setNumberArray("furniture_allowed_directions", _directions, true);
            object.getModelController().setNumber("furniture_alpha_multiplier", 1);
        }

        protected function getAdClickUrl(modelController:IRoomObjectModelController):String
        {
            return (modelController.getString("furniture_ad_url"));
        }

        protected function handleAdClick(objectId:int, objectType:String, adUrl:String):void
        {
            if (eventDispatcher != null)
            {
                eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent("RORAE_ROOM_AD_FURNI_CLICK", object));
            };
        }

        override public function mouseEvent(spriteMouseEvent:RoomSpriteMouseEvent, roomGeometry:IRoomGeometry):void
        {
            var mouseEvent:RoomObjectEvent;

            if (((spriteMouseEvent == null) || (roomGeometry == null)))
            {
                return;
            };

            if (object == null)
            {
                return;
            };

            var modelController:IRoomObjectModelController = (object.getModel() as IRoomObjectModelController);

            if (modelController == null)
            {
                return;
            };

            var adClickUrl:String = getAdClickUrl(modelController);
            switch (spriteMouseEvent.type)
            {
                case "mouseMove":

                    if (eventDispatcher != null)
                    {
                        mouseEvent = new RoomObjectMouseEvent("ROE_MOUSE_MOVE", object, spriteMouseEvent.eventId, spriteMouseEvent.altKey, spriteMouseEvent.ctrlKey, spriteMouseEvent.shiftKey, spriteMouseEvent.buttonDown);
                        (mouseEvent as RoomObjectMouseEvent).localX = spriteMouseEvent.localX;
                        (mouseEvent as RoomObjectMouseEvent).localY = spriteMouseEvent.localY;
                        (mouseEvent as RoomObjectMouseEvent).spriteOffsetX = spriteMouseEvent.spriteOffsetX;
                        (mouseEvent as RoomObjectMouseEvent).spriteOffsetY = spriteMouseEvent.spriteOffsetY;
                        eventDispatcher.dispatchEvent(mouseEvent);
                    };

                    return;
                case "rollOver":

                    if (!_mouseOver)
                    {
                        if ((((!(eventDispatcher == null)) && (!(adClickUrl == null))) && (adClickUrl.indexOf("http") == 0)))
                        {
                            eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent("RORAE_ROOM_AD_TOOLTIP_SHOW", object));
                        };

                        if (eventDispatcher != null)
                        {
                            mouseEvent = new RoomObjectMouseEvent("ROE_MOUSE_ENTER", object, spriteMouseEvent.eventId, spriteMouseEvent.altKey, spriteMouseEvent.ctrlKey, spriteMouseEvent.shiftKey, spriteMouseEvent.buttonDown);
                            (mouseEvent as RoomObjectMouseEvent).localX = spriteMouseEvent.localX;
                            (mouseEvent as RoomObjectMouseEvent).localY = spriteMouseEvent.localY;
                            (mouseEvent as RoomObjectMouseEvent).spriteOffsetX = spriteMouseEvent.spriteOffsetX;
                            (mouseEvent as RoomObjectMouseEvent).spriteOffsetY = spriteMouseEvent.spriteOffsetY;
                            eventDispatcher.dispatchEvent(mouseEvent);
                        };

                        _mouseOver = true;
                    };

                    return;
                case "rollOut":

                    if (_mouseOver)
                    {
                        if ((((!(eventDispatcher == null)) && (!(adClickUrl == null))) && (adClickUrl.indexOf("http") == 0)))
                        {
                            eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent("RORAE_ROOM_AD_TOOLTIP_HIDE", object));
                        };

                        if (eventDispatcher != null)
                        {
                            mouseEvent = new RoomObjectMouseEvent("ROE_MOUSE_LEAVE", object, spriteMouseEvent.eventId, spriteMouseEvent.altKey, spriteMouseEvent.ctrlKey, spriteMouseEvent.shiftKey, spriteMouseEvent.buttonDown);
                            (mouseEvent as RoomObjectMouseEvent).localX = spriteMouseEvent.localX;
                            (mouseEvent as RoomObjectMouseEvent).localY = spriteMouseEvent.localY;
                            (mouseEvent as RoomObjectMouseEvent).spriteOffsetX = spriteMouseEvent.spriteOffsetX;
                            (mouseEvent as RoomObjectMouseEvent).spriteOffsetY = spriteMouseEvent.spriteOffsetY;
                            eventDispatcher.dispatchEvent(mouseEvent);
                        };

                        _mouseOver = false;
                    };

                    return;
                case "doubleClick":
                    useObject();
                    return;
                case "click":

                    if (eventDispatcher != null)
                    {
                        mouseEvent = new RoomObjectMouseEvent("ROE_MOUSE_CLICK", object, spriteMouseEvent.eventId, spriteMouseEvent.altKey, spriteMouseEvent.ctrlKey, spriteMouseEvent.shiftKey, spriteMouseEvent.buttonDown);
                        (mouseEvent as RoomObjectMouseEvent).localX = spriteMouseEvent.localX;
                        (mouseEvent as RoomObjectMouseEvent).localY = spriteMouseEvent.localY;
                        (mouseEvent as RoomObjectMouseEvent).spriteOffsetX = spriteMouseEvent.spriteOffsetX;
                        (mouseEvent as RoomObjectMouseEvent).spriteOffsetY = spriteMouseEvent.spriteOffsetY;
                        eventDispatcher.dispatchEvent(mouseEvent);
                    };

                    if ((((!(eventDispatcher == null)) && (!(adClickUrl == null))) && (adClickUrl.indexOf("http") == 0)))
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent("RORAE_ROOM_AD_TOOLTIP_HIDE", object));
                    };

                    if (((!(eventDispatcher == null)) && (!(adClickUrl == null))))
                    {
                        handleAdClick(object.getId(), object.getType(), adClickUrl);
                    };

                    if ((((!(eventDispatcher == null)) && (!(object == null))) && (!(contextMenu == null))))
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent("ROWRE_OPEN_FURNI_CONTEXT_MENU", object));
                    };

                    return;
                case "mouseDown":

                    if (eventDispatcher != null)
                    {
                        mouseEvent = new RoomObjectMouseEvent("ROE_MOUSE_DOWN", object, spriteMouseEvent.eventId, spriteMouseEvent.altKey, spriteMouseEvent.ctrlKey, spriteMouseEvent.shiftKey, spriteMouseEvent.buttonDown);
                        eventDispatcher.dispatchEvent(mouseEvent);
                    };

                    return;
                default:
                    return;
            };
        }

        override public function useObject():void
        {
            var modelController:IRoomObjectModelController;
            var adClickUrl:String;

            if (object != null)
            {
                modelController = (object.getModel() as IRoomObjectModelController);

                if (modelController != null)
                {
                    adClickUrl = getAdClickUrl(modelController);

                    if ((((!(eventDispatcher == null)) && (!(adClickUrl == null))) && (adClickUrl.length > 0)))
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent("RORAE_ROOM_AD_FURNI_DOUBLE_CLICK", object, null, adClickUrl));
                    };
                };

                if (eventDispatcher != null)
                {
                    if (widget != null)
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent("ROWRE_OPEN_WIDGET", object));
                    };

                    eventDispatcher.dispatchEvent(new RoomObjectStateChangeEvent("ROSCE_STATE_CHANGE", object));
                };
            };
        }

        private function handleDataUpdateMessage(dataUpdateMessage:RoomObjectDataUpdateMessage):void
        {
            var modelController:IRoomObjectModelController = object.getModelController();
            object.setState(dataUpdateMessage.state, 0);

            if (modelController != null)
            {
                if (dataUpdateMessage.data != null)
                {
                    dataUpdateMessage.data.writeRoomObjectModel(modelController);
                };

                if (!isNaN(dataUpdateMessage.extra))
                {
                    modelController.setString("furniture_extras", String(dataUpdateMessage.extra));
                };

                modelController.setNumber("furniture_state_update_time", lastUpdateTime);
            };
        }

        private function handleHeightUpdateMessage(heightUpdateMessage:RoomObjectHeightUpdateMessage):void
        {
            var modelController:IRoomObjectModelController = object.getModelController();

            if (modelController != null)
            {
                modelController.setNumber("furniture_size_z", heightUpdateMessage.height);
            };
        }

        private function handleItemDataUpdateMessage(itemDataUpdateMessage:RoomObjectItemDataUpdateMessage):void
        {
            var modelController:IRoomObjectModelController = object.getModelController();

            if (modelController != null)
            {
                modelController.setString("furniture_itemdata", itemDataUpdateMessage.itemData);
            };
        }

        override public function processUpdateMessage(_arg_1:RoomObjectUpdateMessage):void
        {
            var _local_5:IVector3d;
            var _local_2:IVector3d;
            var _local_7:String;
            var _local_8:RoomObjectDataUpdateMessage = (_arg_1 as RoomObjectDataUpdateMessage);

            if (_local_8 != null)
            {
                handleDataUpdateMessage(_local_8);
                return;
            };

            var _local_4:RoomObjectHeightUpdateMessage = (_arg_1 as RoomObjectHeightUpdateMessage);

            if (_local_4 != null)
            {
                handleHeightUpdateMessage(_local_4);
                return;
            };

            var _local_6:RoomObjectItemDataUpdateMessage = (_arg_1 as RoomObjectItemDataUpdateMessage);

            if (_local_6 != null)
            {
                handleItemDataUpdateMessage(_local_6);
                return;
            };

            _mouseOver = false;

            if (((!(_arg_1.dir == null)) && (!(_arg_1.loc == null))))
            {
                if (!(_arg_1 is RoomObjectMoveUpdateMessage))
                {
                    _local_5 = object.getDirection();
                    _local_2 = object.getLocation();

                    if ((((((((!(_local_5 == null)) && (!(_local_5.x == _arg_1.dir.x))) && (_directionInitialized)) && (!(_local_2 == null))) && (_local_2.x == _arg_1.loc.x)) && (_local_2.y == _arg_1.loc.y)) && (_local_2.z == _arg_1.loc.z)))
                    {
                        _bouncingStep = 1;
                        _storedRotateMessage = new RoomObjectUpdateMessage(_arg_1.loc, _arg_1.dir);
                        _arg_1 = null;
                    };
                };

                _directionInitialized = true;
            };

            var _local_3:RoomObjectSelectedMessage = (_arg_1 as RoomObjectSelectedMessage);

            if (((((!(contextMenu == null)) && (!(_local_3 == null))) && (!(eventDispatcher == null))) && (!(object == null))))
            {
                _local_7 = ((_local_3.selected) ? "ROWRE_OPEN_FURNI_CONTEXT_MENU" : "ROWRE_CLOSE_FURNI_CONTEXT_MENU");
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(_local_7, object));
            };

            super.processUpdateMessage(_arg_1);
        }

        override protected function getLocationOffset():IVector3d
        {
            if (_bouncingStep > 0)
            {
                _locationOffset.x = 0;
                _locationOffset.y = 0;

                if (_bouncingStep <= (8 / 2))
                {
                    _locationOffset.z = (0.0625 * _bouncingStep);
                }

                else
                {
                    if (_bouncingStep <= 8)
                    {
                        if (_storedRotateMessage)
                        {
                            super.processUpdateMessage(_storedRotateMessage);
                            _storedRotateMessage = null;
                        };

                        _locationOffset.z = (0.0625 * (8 - _bouncingStep));
                    };
                };

                return (_locationOffset);
            };

            return (null);
        }

        override public function update(_arg_1:int):void
        {
            super.update(_arg_1);

            if (_bouncingStep > 0)
            {
                _bouncingStep++;

                if (_bouncingStep > 8)
                {
                    _bouncingStep = 0;
                };
            };
        }

        override public function tearDown():void
        {
            if (((!(widget == null)) && (object.getModelController().getNumber("furniture_real_room_object") == 1)))
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent("ROWRE_CLOSE_WIDGET", object));
            };

            super.tearDown();
        }

    }
}
