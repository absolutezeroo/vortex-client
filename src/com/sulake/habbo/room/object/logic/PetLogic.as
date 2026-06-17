package com.sulake.habbo.room.object.logic
{
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectMoveEvent;
    import com.sulake.room.utils.XmlUtil;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPostureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarChatUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPetGestureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSleepUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSelectedMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarExperienceUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarFigureUpdateMessage;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.room.object.IRoomObjectModelController;
    import flash.utils.getTimer;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

    public class PetLogic extends MovingObjectLogic
    {

        private var _talkingEndTimeStamp:int = 0;
        private var _gestureEndTimeStamp:int = 0;
        private var _expressionEndTimeStamp:int = 0;
        private var _selected:Boolean = false;
        private var _reportedLoc:Vector3d = null;
        private var _debugMode:Boolean = false;
        private var _postureIndex:int = 0;
        private var _gestureIndex:int = 0;
        private var _headDirectionDelta:int = 0;
        private var _debugDirectionIndex:int = 0;
        private var _directions:Array = [];

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROE_MOUSE_CLICK", "ROME_POSITION_CHANGED"];
            return (getAllEventTypes(super.getEventTypes(), eventTypes));
        }

        override public function dispose():void
        {
            var removedEvent:RoomObjectEvent;

            if (((_selected) && (!(object == null))))
            {
                if (eventDispatcher != null)
                {
                    removedEvent = new RoomObjectMoveEvent("ROME_OBJECT_REMOVED", object);
                    eventDispatcher.dispatchEvent(removedEvent);
                };
            };

            _directions = null;
            super.dispose();
            _reportedLoc = null;
        }

        override public function initialize(data:XML):void
        {
            var i:int;
            var directionXml:XML;
            var directionId:int;
            super.initialize(data);
            _directions = [];

            var directionList:XMLList = data.model.directions.direction;
            var requiredAttributes:Array = ["id"];
            i = 0;

            while (i < directionList.length())
            {
                directionXml = directionList[i];

                if (XmlUtil.checkRequiredAttributes(directionXml, requiredAttributes))
                {
                    directionId = parseInt(directionXml.@id);
                    _directions.push(directionId);
                };

                i++;
            };

            _directions.sort(16);
            object.getModelController().setNumberArray("pet_allowed_directions", _directions, true);
        }

        override public function processUpdateMessage(message:RoomObjectUpdateMessage):void
        {
            var postureMessage:RoomObjectAvatarPostureUpdateMessage;
            var avatarMessage:RoomObjectAvatarUpdateMessage;
            var chatMessage:RoomObjectAvatarChatUpdateMessage;
            var gestureMessage:RoomObjectAvatarPetGestureUpdateMessage;
            var sleepMessage:RoomObjectAvatarSleepUpdateMessage;
            var selectedMessage:RoomObjectAvatarSelectedMessage;
            var experienceMessage:RoomObjectAvatarExperienceUpdateMessage;
            var figureMessage:RoomObjectAvatarFigureUpdateMessage;
            var previousFigure:String;
            var figureData:PetFigureData;

            if (((message == null) || (object == null)))
            {
                return;
            };

            var modelController:IRoomObjectModelController = object.getModelController();

            if (!_debugMode)
            {
                super.processUpdateMessage(message);

                if ((message is RoomObjectAvatarPostureUpdateMessage))
                {
                    postureMessage = (message as RoomObjectAvatarPostureUpdateMessage);
                    modelController.setString("figure_posture", postureMessage.postureType);
                    return;
                };

                if ((message is RoomObjectAvatarUpdateMessage))
                {
                    avatarMessage = (message as RoomObjectAvatarUpdateMessage);
                    modelController.setNumber("head_direction", avatarMessage.dirHead);
                    return;
                };

                if ((message is RoomObjectAvatarChatUpdateMessage))
                {
                    chatMessage = (message as RoomObjectAvatarChatUpdateMessage);
                    modelController.setNumber("figure_talk", 1);
                    _talkingEndTimeStamp = (getTimer() + (chatMessage.numberOfWords * 1000));
                    return;
                };

                if ((message is RoomObjectAvatarPetGestureUpdateMessage))
                {
                    gestureMessage = (message as RoomObjectAvatarPetGestureUpdateMessage);
                    modelController.setString("figure_gesture", gestureMessage.gesture);
                    _gestureEndTimeStamp = (getTimer() + 3000);
                    return;
                };

                if ((message is RoomObjectAvatarSleepUpdateMessage))
                {
                    sleepMessage = (message as RoomObjectAvatarSleepUpdateMessage);
                    modelController.setNumber("figure_sleep", Number(sleepMessage.isSleeping));
                    return;
                };
            };

            if ((message is RoomObjectAvatarSelectedMessage))
            {
                selectedMessage = (message as RoomObjectAvatarSelectedMessage);
                _selected = selectedMessage.selected;
                _reportedLoc = null;
                return;
            };

            if ((message is RoomObjectAvatarExperienceUpdateMessage))
            {
                experienceMessage = (message as RoomObjectAvatarExperienceUpdateMessage);
                modelController.setNumber("figure_experience_timestamp", getTimer());
                modelController.setNumber("figure_gained_experience", experienceMessage.gainedExperience);
                return;
            };

            if ((message is RoomObjectAvatarFigureUpdateMessage))
            {
                figureMessage = (message as RoomObjectAvatarFigureUpdateMessage);
                previousFigure = modelController.getString("figure");
                figureData = new PetFigureData(figureMessage.figure);
                modelController.setString("figure", figureMessage.figure);
                modelController.setString("race", figureMessage.race);
                modelController.setNumber("pet_palette_index", figureData.paletteId);
                modelController.setNumber("pet_color", figureData.color);
                modelController.setNumber("pet_type", figureData.typeId);
                modelController.setNumberArray("pet_custom_layer_ids", figureData.customLayerIds);
                modelController.setNumberArray("pet_custom_part_ids", figureData.customPartIds);
                modelController.setNumberArray("pet_custom_palette_ids", figureData.customPaletteIds);
                modelController.setNumber("pet_is_riding", ((figureMessage.isRiding) ? 1 : 0));
                return;
            };
        }

        override public function mouseEvent(mouseEvt:RoomSpriteMouseEvent, geometry:IRoomGeometry):void
        {
            var petType:int;
            var roomObjectEvent:RoomObjectEvent;

            if (((object == null) || (mouseEvt == null)))
            {
                return;
            };

            var modelController:IRoomObjectModelController = object.getModelController();
            var targetLoc:IVector3d;
            var directionVector:Vector3d;
            var eventType:String;
            switch (mouseEvt.type)
            {
                case "click":
                    eventType = "ROE_MOUSE_CLICK";

                    if (_debugMode)
                    {
                        debugMouseEvent(mouseEvt);
                    };

                    break;
                case "doubleClick":
                    break;
                case "mouseDown":

                    if (!_debugMode)
                    {
                        petType = modelController.getNumber("pet_type");

                        if (petType == 16)
                        {
                            if (eventDispatcher != null)
                            {
                                roomObjectEvent = new RoomObjectMouseEvent("ROE_MOUSE_DOWN", object, mouseEvt.eventId, mouseEvt.altKey, mouseEvt.ctrlKey, mouseEvt.shiftKey, mouseEvt.buttonDown);
                                eventDispatcher.dispatchEvent(roomObjectEvent);
                            };
                        };
                    };
            };

            if (eventType != null)
            {
                if (eventDispatcher != null)
                {
                    roomObjectEvent = new RoomObjectMouseEvent(eventType, object, mouseEvt.eventId, mouseEvt.altKey, mouseEvt.ctrlKey, mouseEvt.shiftKey, mouseEvt.buttonDown);
                    eventDispatcher.dispatchEvent(roomObjectEvent);
                };
            };
        }

        private function debugMouseEvent(mouseEvt:RoomSpriteMouseEvent):void
        {
            var direction:int;
            var modelController:IRoomObjectModelController = object.getModelController();

            if (((!(mouseEvt.altKey)) && (!(mouseEvt.ctrlKey))))
            {
                direction = _directions[_debugDirectionIndex];
                object.setDirection(new Vector3d(direction));
                modelController.setNumber("head_direction", (direction + _headDirectionDelta));
                _debugDirectionIndex++;

                if (_debugDirectionIndex == _directions.length)
                {
                    _debugDirectionIndex = 0;
                };
            }

            else
            {
                if (((mouseEvt.altKey) && (!(mouseEvt.ctrlKey))))
                {
                    _postureIndex++;
                    modelController.setNumber("figure_posture", _postureIndex);
                    modelController.setNumber("figure_gesture", NaN);
                }

                else
                {
                    if (((mouseEvt.ctrlKey) && (!(mouseEvt.altKey))))
                    {
                        _gestureIndex++;
                        modelController.setNumber("figure_gesture", _gestureIndex);
                    }

                    else
                    {
                        _headDirectionDelta = (_headDirectionDelta + 45);

                        if (_headDirectionDelta > 45)
                        {
                            _headDirectionDelta = -45;
                        };

                        direction = object.getDirection().x;
                        modelController.setNumber("head_direction", (direction + _headDirectionDelta));
                    };
                };
            };
        }

        override public function update(time:int):void
        {
            var currentLoc:IVector3d;
            var positionChangedEvent:RoomObjectEvent;
            super.update(time);

            if (((_selected) && (!(object == null))))
            {
                if (eventDispatcher != null)
                {
                    currentLoc = object.getLocation();

                    if (((((_reportedLoc == null) || (!(_reportedLoc.x == currentLoc.x))) || (!(_reportedLoc.y == currentLoc.y))) || (!(_reportedLoc.z == currentLoc.z))))
                    {
                        if (_reportedLoc == null)
                        {
                            _reportedLoc = new Vector3d();
                        };

                        _reportedLoc.assign(currentLoc);
                        positionChangedEvent = new RoomObjectMoveEvent("ROME_POSITION_CHANGED", object);
                        eventDispatcher.dispatchEvent(positionChangedEvent);
                    };
                };
            };

            if (((!(object == null)) && (!(object.getModelController() == null))))
            {
                updateActions(time, object.getModelController());
            };
        }

        private function updateActions(time:int, modelController:IRoomObjectModelController):void
        {
            if (((_gestureEndTimeStamp > 0) && (time > _gestureEndTimeStamp)))
            {
                modelController.setString("figure_gesture", null);
                _gestureEndTimeStamp = 0;
            };

            if (_talkingEndTimeStamp > 0)
            {
                if (time > _talkingEndTimeStamp)
                {
                    modelController.setNumber("figure_talk", 0);
                    _talkingEndTimeStamp = 0;
                };
            };

            if (((_expressionEndTimeStamp > 0) && (time > _expressionEndTimeStamp)))
            {
                modelController.setNumber("figure_expression", 0);
                _expressionEndTimeStamp = 0;
            };
        }

    }
}
