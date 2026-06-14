package com.sulake.habbo.ui.handler
{
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.habbo.ui.RoomDesktop;
    import com.sulake.core.communication.messages.IMessageEvent;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.communication.messages.parser.crafting.CraftableProductsMessageEvent;
    import com.sulake.habbo.communication.messages.parser.crafting.CraftingRecipeMessageEvent;
    import com.sulake.habbo.communication.messages.parser.crafting.CraftingResultMessageEvent;
    import com.sulake.habbo.communication.messages.parser.crafting.CraftingRecipesAvailableMessageEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryFurniListParsedEvent;
    import com.sulake.habbo.communication.messages.outgoing.crafting.GetCraftableProductsComposer;
    import com.sulake.habbo.communication.messages.outgoing.crafting.GetCraftingRecipeComposer;
    import com.sulake.habbo.communication.messages.outgoing.crafting.GetCraftingRecipesAvailableComposer;
    import com.sulake.habbo.communication.messages.outgoing.crafting.CraftComposer;
    import com.sulake.habbo.communication.messages.outgoing.crafting.CraftSecretComposer;
    import com.sulake.habbo.communication.messages.parser.crafting.FurnitureProductItem;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniListInvalidateEvent;
    import com.sulake.habbo.communication.messages.outgoing.inventory.furni.RequestFurniInventoryComposer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineToWidgetEvent;
    import com.sulake.room.object.IRoomObject;
    import flash.events.Event;

    public class CraftingWidgetHandler implements IRoomWidgetHandler 
    {

        private var _disposed:Boolean = false;
        private var _container:IRoomWidgetHandlerContainer;
        private var _widget:CraftingWidget;
        private var _roomDesktop:RoomDesktop;
        private var _inventoryUpdateEvent:IMessageEvent;
        private var _messageEvents:Vector.<IMessageEvent>;
        private var _gizmoFurnitureId:int;
        private var _waitingForInitialData:Boolean;
        private var _inventoryDirty:Boolean;
        private var _craftingInProgress:Boolean;
        private var _selectedProductData:IProductData;

        public function CraftingWidgetHandler(_arg_1:RoomDesktop)
        {
            _roomDesktop = _arg_1;
        }

        public function dispose():void
        {
            removeMessageEvents();
            _widget = null;
            _container = null;
            _roomDesktop = null;
            _selectedProductData = null;
            _disposed = true;
        }

        private function addMessageEvents():void
        {
            if (((!(_container)) || (!(_container.connection))))
            {
                return;
            };

            _messageEvents = new Vector.<IMessageEvent>(0);
            _messageEvents.push(new CraftableProductsMessageEvent(onCraftableProductsMessage));
            _messageEvents.push(new CraftingRecipeMessageEvent(onCraftingRecipeMessage));
            _messageEvents.push(new CraftingResultMessageEvent(onCraftingResultMessage));
            _messageEvents.push(new CraftingRecipesAvailableMessageEvent(onCraftingRecipesAvailableMessage));

            for each (var _local_1:IMessageEvent in _messageEvents)
            {
                _container.connection.addMessageEvent(_local_1);
            };
        }

        private function removeMessageEvents():void
        {
            if ((((!(_container)) || (!(_container.connection))) || (!(_messageEvents))))
            {
                return;
            };

            for each (var _local_1:IMessageEvent in _messageEvents)
            {
                _container.connection.removeMessageEvent(_local_1);
                _local_1.dispose();
            };

            removeInventoryUpdateEvent();

            if (((_container.inventory) && (_container.inventory.events)))
            {
                _container.inventory.events.removeEventListener("HFLPE_FURNI_LIST_PARSED", onFurniListParsed);
            };

            _messageEvents = null;
        }

        public function initializeData():void
        {
            if (_waitingForInitialData)
            {
                return;
            };

            _waitingForInitialData = true;

            if (_container.inventory.checkCategoryInitilization("furni"))
            {
                getCraftableProducts();
            };
        }

        private function onFurniListParsed(_arg_1:HabboInventoryFurniListParsedEvent):void
        {
            if (((_waitingForInitialData) && (_arg_1.category == "furni")))
            {
                getCraftableProducts();
            };
        }

        private function getCraftableProducts():void
        {
            _container.connection.send(new GetCraftableProductsComposer(_gizmoFurnitureId));
        }

        private function onCraftableProductsMessage(_arg_1:CraftableProductsMessageEvent):void
        {
            _waitingForInitialData = false;

            if (!_widget)
            {
                return;
            };

            if (!_arg_1.getParser().hasData())
            {
                _widget.hide();
                return;
            };

            _widget.showWidget();
            _widget.showCraftingCategories(_arg_1.getParser().recipeProductItems, _arg_1.getParser().usableInventoryFurniClasses, _container.roomEngine, _container.sessionDataManager);
            _inventoryDirty = false;
        }

        public function getCraftingRecipe(_arg_1:String):void
        {
            _selectedProductData = _container.sessionDataManager.getProductData(_arg_1);
            _container.connection.send(new GetCraftingRecipeComposer(_arg_1));
        }

        private function onCraftingRecipeMessage(_arg_1:CraftingRecipeMessageEvent):void
        {
            _widget.showCraftingRecipe(_arg_1.getParser().ingredients);
        }

        public function getCraftingRecipesAvailable(_arg_1:Vector.<int>):void
        {
            _container.connection.send(new GetCraftingRecipesAvailableComposer(_gizmoFurnitureId, _arg_1));
        }

        private function onCraftingRecipesAvailableMessage(_arg_1:CraftingRecipesAvailableMessageEvent):void
        {
            _widget.infoCtrl.craftingSecretRecipesAvailable(_arg_1.getParser().count, _arg_1.getParser().recipeComplete);
        }

        public function doCraftingWithRecipe():void
        {
            if (!_selectedProductData)
            {
                return;
            };

            _widget.infoCtrl.setState(1000);
            registerForFurniListInvalidate();
            _container.connection.send(new CraftComposer(_gizmoFurnitureId, _selectedProductData.type));
        }

        public function doCraftingWithMixer():void
        {
            _widget.infoCtrl.setState(1000);

            var _local_1:Vector.<int> = _widget.getSelectedIngredients();
            registerForFurniListInvalidate();
            _container.connection.send(new CraftSecretComposer(_gizmoFurnitureId, _local_1));
        }

        private function onCraftingResultMessage(_arg_1:CraftingResultMessageEvent):void
        {
            var _local_2:FurnitureProductItem;
            var _local_3:IFurnitureData;
            _craftingInProgress = false;

            if (!_arg_1.getParser().success)
            {
                _widget.clearMixerItems();
                _inventoryDirty = false;
                removeInventoryUpdateEvent();
                _widget.setInfoState(1);
            }

            else
            {
                _widget.clearMixerItems();
                _local_2 = _arg_1.getParser().productData;
                _local_3 = _container.sessionDataManager.getFloorItemDataByName(_local_2.furnitureClassName);

                if (!_local_3)
                {
                    return;
                };

                _widget.setInfoState(999, _local_3);
            };
        }

        private function registerForFurniListInvalidate():void
        {
            _inventoryDirty = true;

            if (_inventoryUpdateEvent == null)
            {
                _inventoryUpdateEvent = new FurniListInvalidateEvent(onFurniListInvalidate);
                _container.connection.addMessageEvent(_inventoryUpdateEvent);
            };
        }

        private function onFurniListInvalidate(_arg_1:FurniListInvalidateEvent):void
        {
            _container.connection.send(new RequestFurniInventoryComposer());
            _container.connection.send(new GetCraftableProductsComposer(_gizmoFurnitureId));
            removeInventoryUpdateEvent();
        }

        public function removeInventoryUpdateEvent():void
        {
            if (_inventoryUpdateEvent)
            {
                _container.connection.removeMessageEvent(_inventoryUpdateEvent);
                _inventoryUpdateEvent = null;
            };
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get type():String
        {
            return ("RWE_CRAFTING");
        }

        public function set container(_arg_1:IRoomWidgetHandlerContainer):void
        {
            _container = _arg_1;
            addMessageEvents();

            if (((_container.inventory) && (_container.inventory.events)))
            {
                _container.inventory.events.addEventListener("HFLPE_FURNI_LIST_PARSED", onFurniListParsed);
            };
        }

        public function get container():IRoomWidgetHandlerContainer
        {
            return (_container);
        }

        public function set widget(_arg_1:CraftingWidget):void
        {
            _widget = _arg_1;
        }

        public function getWidgetMessages():Array
        {
            return (null);
        }

        public function processWidgetMessage(_arg_1:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return (null);
        }

        public function getProcessedEvents():Array
        {
            return (["RETWE_OPEN_WIDGET", "RETWE_CLOSE_WIDGET"]);
        }

        public function processEvent(_arg_1:Event):void
        {
            if (((_container.roomEngine == null) || (_widget == null)))
            {
                return;
            };

            var _local_3:RoomEngineToWidgetEvent = (_arg_1 as RoomEngineToWidgetEvent);

            if (_local_3 == null)
            {
                return;
            };

            var _local_2:IRoomObject = _container.roomEngine.getRoomObject(_local_3.roomId, _local_3.objectId, _local_3.category);
            switch (_arg_1.type)
            {
                case "RETWE_OPEN_WIDGET":

                    if (_widget.window != null)
                    {
                        return;
                    };

                    if (_local_2 != null)
                    {
                        _gizmoFurnitureId = _local_2.getId();
                        initializeData();
                    };

                    return;
                case "RETWE_CLOSE_WIDGET":
                    _gizmoFurnitureId = -1;
                    _widget.hide();
                    return;
            };
        }

        public function get isOwner():Boolean
        {
            var _local_1:int = _container.roomEngine.activeRoomId;
            var _local_2:IRoomObject = _container.roomEngine.getRoomObject(_local_1, _gizmoFurnitureId, 10);
            return ((!(_local_2 == null)) && (_container.isOwnerOfFurniture(_local_2)));
        }

        public function get craftingInProgress():Boolean
        {
            return (_craftingInProgress);
        }

        public function set craftingInProgress(_arg_1:Boolean):void
        {
            _craftingInProgress = _arg_1;
        }

        public function get inventoryDirty():Boolean
        {
            return (_inventoryDirty);
        }

        public function update():void
        {
        }

    }
}
