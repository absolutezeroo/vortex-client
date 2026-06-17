package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

    public class FurnitureDiceLogic extends FurnitureLogic 
    {

        private var _noTags:Boolean = false;
        private var _noTagsLastStateActivate:Boolean = false;

        override public function getEventTypes():Array
        {
            var _eventTypes:Array = ["ROFCAE_DICE_ACTIVATE", "ROFCAE_DICE_OFF"];
            return (getAllEventTypes(super.getEventTypes(), _eventTypes));
        }

        override public function initialize(_model:XML):void
        {
            super.initialize(_model);

            if (_model == null)
            {
                return;
            };

            var _allSpritesActivate:XMLList = _model.allspritesactivate;

            if (_allSpritesActivate.length() == 0)
            {
                _noTags = false;
            }

            else
            {
                _noTags = true;
            };
        }

        override public function mouseEvent(_mouseEvent:RoomSpriteMouseEvent, _geometry:IRoomGeometry):void
        {
            var _actionEvent:RoomObjectEvent;

            if (((_mouseEvent == null) || (_geometry == null)))
            {
                return;
            };

            if (object == null)
            {
                return;
            };

            switch (_mouseEvent.type)
            {
                case "doubleClick":

                    if (eventDispatcher != null)
                    {
                        if (_noTags)
                        {
                            if ((((!(_noTagsLastStateActivate)) || (object.getState(0) == 0)) || (object.getState(0) == 100)))
                            {
                                _actionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_DICE_ACTIVATE", object);
                                _noTagsLastStateActivate = true;
                            }

                            else
                            {
                                _actionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_DICE_OFF", object);
                                _noTagsLastStateActivate = false;
                            };
                        }

                        else
                        {
                            if ((((_mouseEvent.spriteTag == "activate") || (object.getState(0) == 0)) || (object.getState(0) == 100)))
                            {
                                _actionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_DICE_ACTIVATE", object);
                            }

                            else
                            {
                                if (_mouseEvent.spriteTag == "deactivate")
                                {
                                    _actionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_DICE_OFF", object);
                                };
                            };
                        };

                        if (_actionEvent != null)
                        {
                            eventDispatcher.dispatchEvent(_actionEvent);
                        };
                    };

                    return;
                default:
                    super.mouseEvent(_mouseEvent, _geometry);
                    return;
            };
        }

    }
}
