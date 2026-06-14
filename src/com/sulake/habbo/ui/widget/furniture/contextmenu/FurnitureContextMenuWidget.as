package com.sulake.habbo.ui.widget.furniture.contextmenu
{
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.ui.widget.contextmenu.IContextMenuParentWidget;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.runtime.Component;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.ui.widget.furniture.guildfurnicontextmenu.GuildFurnitureContextMenuView;
    import com.sulake.habbo.ui.widget.furniture.effectbox.EffectBoxOpenDialogView;
    import com.sulake.habbo.ui.widget.furniture.mysterybox.MysteryBoxContextMenuView;
    import com.sulake.habbo.ui.widget.furniture.mysterytrophy.MysteryTrophyOpenDialogView;
    import com.sulake.habbo.ui.widget.furniture.mysterybox.MysteryBoxOpenDialogView;
    import com.sulake.habbo.ui.widget.furniture.friendfurni.FriendFurniContextMenuView;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ICoreConfiguration;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.groups.IHabboGroupsManager;
    import com.sulake.habbo.ui.handler.FurnitureContextMenuWidgetHandler;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.ui.widget.contextmenu.ContextInfoView;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.friendlist.IHabboFriendList;

    public class FurnitureContextMenuWidget extends RoomWidgetBase implements IContextMenuParentWidget, IUpdateReceiver 
    {

        private var _component:Component;
        private var _view:FurnitureContextInfoView;
        private var _selectedObject:IRoomObject = null;
        private var _cachedGuildFurniContextView:GuildFurnitureContextMenuView;
        private var _cachedRandomTeleportContextView:RandomTeleportContextMenuView;
        private var _cachedMonsterPlantSeedContextView:MonsterPlantSeedContextMenuView;
        private var _cachedMonsterPlantSeedConfirmationView:MonsterPlantSeedConfirmationView;
        private var _cachedEffectBoxOpenDialogView:EffectBoxOpenDialogView;
        private var _cachedMysteryBoxContextView:MysteryBoxContextMenuView;
        private var _cachedMysteryTrophyOpenDialogView:MysteryTrophyOpenDialogView;
        private var _cachedMysteryBoxOpenDialogView:MysteryBoxOpenDialogView;
        private var _cachedFriendFurnitureContextView:FriendFurniContextMenuView;
        private var _cachedUsableFurnitureContextView:GenericUsableFurnitureContextMenuView;
        private var _catalog:IHabboCatalog;
        private var _container:IRoomWidgetHandlerContainer = null;
        private var _cachedPurchasableClothingConfirmationView:PurchasableClothingConfirmationView;

        public function FurnitureContextMenuWidget(_arg_1:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:ICoreConfiguration, _arg_5:IHabboLocalizationManager, _arg_6:Component, _arg_7:IHabboGroupsManager, _arg_8:IHabboCatalog)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_5);
            _component = _arg_6;
            _cachedGuildFurniContextView = new GuildFurnitureContextMenuView(this, _arg_7, _arg_2);
            _cachedRandomTeleportContextView = new RandomTeleportContextMenuView(this);
            _cachedMonsterPlantSeedContextView = new MonsterPlantSeedContextMenuView(this);
            _cachedMysteryBoxContextView = new MysteryBoxContextMenuView(this);
            _cachedFriendFurnitureContextView = new FriendFurniContextMenuView(this);
            _cachedUsableFurnitureContextView = new GenericUsableFurnitureContextMenuView(this);
            _cachedMonsterPlantSeedConfirmationView = new MonsterPlantSeedConfirmationView(this);
            _cachedMysteryBoxOpenDialogView = new MysteryBoxOpenDialogView(this);
            _cachedEffectBoxOpenDialogView = new EffectBoxOpenDialogView(this);
            _cachedMysteryTrophyOpenDialogView = new MysteryTrophyOpenDialogView(this);
            _cachedPurchasableClothingConfirmationView = new PurchasableClothingConfirmationView(this);
            _catalog = _arg_8;
            this.handler.widget = this;
            this.handler.roomEngine.events.addEventListener("REOE_REMOVED", onRoomObjectRemoved);
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            };

            _component.removeUpdateReceiver(this);
            removeView(_view, false);
            _cachedGuildFurniContextView.dispose();
            _cachedGuildFurniContextView = null;
            _cachedRandomTeleportContextView.dispose();
            _cachedRandomTeleportContextView = null;
            _cachedMonsterPlantSeedContextView.dispose();
            _cachedMonsterPlantSeedContextView = null;
            _cachedMonsterPlantSeedConfirmationView.dispose();
            _cachedMonsterPlantSeedConfirmationView = null;
            _cachedMysteryBoxContextView.dispose();
            _cachedMysteryBoxContextView = null;
            _cachedMysteryBoxOpenDialogView.dispose();
            _cachedMysteryBoxOpenDialogView = null;
            _cachedFriendFurnitureContextView.dispose();
            _cachedFriendFurnitureContextView = null;
            _cachedUsableFurnitureContextView.dispose();
            _cachedUsableFurnitureContextView = null;
            _cachedEffectBoxOpenDialogView.dispose();
            _cachedEffectBoxOpenDialogView = null;
            _cachedMysteryTrophyOpenDialogView.dispose();
            _cachedMysteryTrophyOpenDialogView = null;
            _cachedPurchasableClothingConfirmationView.dispose();
            _cachedPurchasableClothingConfirmationView = null;
            _catalog = null;
            super.dispose();
        }

        public function set container(_arg_1:IRoomWidgetHandlerContainer):void
        {
            _container = _arg_1;
        }

        public function get container():IRoomWidgetHandlerContainer
        {
            return (_container);
        }

        public function get handler():FurnitureContextMenuWidgetHandler
        {
            return (_SafeStr_3915 as FurnitureContextMenuWidgetHandler);
        }

        public function get roomEngine():IRoomEngine
        {
            return ((_container) ? _container.roomEngine : null);
        }

        public function hideContextMenu(_arg_1:IRoomObject):void
        {
            if (((!(_selectedObject == null)) && (_selectedObject.getId() == _arg_1.getId())))
            {
                removeView(_view, false);
                _component.removeUpdateReceiver(this);
                _selectedObject = null;
            };
        }

        public function showGuildFurnitureContextMenu(_arg_1:IRoomObject, _arg_2:int, _arg_3:String, _arg_4:int, _arg_5:Boolean, _arg_6:Boolean):void
        {
            _selectedObject = _arg_1;
            _cachedGuildFurniContextView._SafeStr_618 = _arg_2;
            _cachedGuildFurniContextView._SafeStr_619 = _arg_4;
            _cachedGuildFurniContextView._SafeStr_620 = _arg_5;
            _cachedGuildFurniContextView._SafeStr_621 = _arg_6;

            if (_view != null)
            {
                removeView(_view, false);
            };

            _view = _cachedGuildFurniContextView;
            FurnitureContextInfoView.setup(_view, _arg_1, _arg_3);
            _component.registerUpdateReceiver(this, 10);
        }

        public function showRandomTeleportContextMenu(_arg_1:IRoomObject, _arg_2:int):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            _cachedRandomTeleportContextView.objectCategory = _arg_2;
            _view = _cachedRandomTeleportContextView;
            FurnitureContextInfoView.setup(_view, _arg_1);
            _component.registerUpdateReceiver(this, 10);
        }

        public function showMonsterPlantSeedContextMenu(_arg_1:IRoomObject, _arg_2:int):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            _cachedMonsterPlantSeedContextView.objectCategory = _arg_2;
            _view = _cachedMonsterPlantSeedContextView;
            FurnitureContextInfoView.setup(_view, _arg_1);
            _component.registerUpdateReceiver(this, 10);
        }

        public function showPlantSeedConfirmationDialog(_arg_1:IRoomObject):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            if (!_cachedMonsterPlantSeedConfirmationView)
            {
                _cachedMonsterPlantSeedConfirmationView = new MonsterPlantSeedConfirmationView(this);
            };

            _cachedMonsterPlantSeedConfirmationView.open(_arg_1.getId());
        }

        public function showPurchasableClothingConfirmationDialog(_arg_1:IRoomObject):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            if (!_cachedPurchasableClothingConfirmationView)
            {
                _cachedPurchasableClothingConfirmationView = new PurchasableClothingConfirmationView(this);
            };

            _cachedPurchasableClothingConfirmationView.open(_arg_1.getId());
        }

        public function showEffectBoxOpenDialog(_arg_1:IRoomObject):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            if (!_cachedEffectBoxOpenDialogView)
            {
                _cachedEffectBoxOpenDialogView = new EffectBoxOpenDialogView(this);
            };

            _cachedEffectBoxOpenDialogView.open(_arg_1.getId());
        }

        public function showMysteryTrophyOpenDialog(_arg_1:IRoomObject):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            if (!_cachedMysteryTrophyOpenDialogView)
            {
                _cachedMysteryTrophyOpenDialogView = new MysteryTrophyOpenDialogView(this);
            };

            _cachedMysteryTrophyOpenDialogView.open(_arg_1.getId());
        }

        private function removePlantSeedConfirmationView():void
        {
            if (_cachedMonsterPlantSeedConfirmationView != null)
            {
                _cachedMonsterPlantSeedConfirmationView.close();
            };
        }

        public function showMysteryBoxContextMenu(_arg_1:IRoomObject):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            if (_cachedMysteryBoxContextView == null)
            {
                _cachedMysteryBoxContextView = new MysteryBoxContextMenuView(this);
            };

            _cachedMysteryBoxContextView.isOwnerMode = handler.container.isOwnerOfFurniture(_arg_1);
            _cachedMysteryBoxContextView.show();
            _view = _cachedMysteryBoxContextView;
            FurnitureContextInfoView.setup(_view, _arg_1);
            _component.registerUpdateReceiver(this, 10);
        }

        public function showFriendFurnitureContextMenu(_arg_1:IRoomObject):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            if (_cachedFriendFurnitureContextView == null)
            {
                _cachedFriendFurnitureContextView = new FriendFurniContextMenuView(this);
            };

            _cachedFriendFurnitureContextView.show();
            _view = _cachedFriendFurnitureContextView;
            FurnitureContextInfoView.setup(_view, _arg_1);
            _component.registerUpdateReceiver(this, 10);
        }

        public function showUsableFurnitureContextMenu(_arg_1:IRoomObject, _arg_2:int):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            if (_cachedUsableFurnitureContextView == null)
            {
                _cachedUsableFurnitureContextView = new GenericUsableFurnitureContextMenuView(this);
            };

            _cachedUsableFurnitureContextView.show();
            _cachedUsableFurnitureContextView.objectCategory = _arg_2;
            _view = _cachedUsableFurnitureContextView;
            FurnitureContextInfoView.setup(_view, _arg_1);
            _component.registerUpdateReceiver(this, 10);
        }

        public function showMysteryBoxOpenDialog(_arg_1:IRoomObject):void
        {
            _selectedObject = _arg_1;

            if (_view != null)
            {
                removeView(_view, false);
            };

            _cachedMysteryBoxOpenDialogView.startOpenFlow(_arg_1);
        }

        public function removeView(_arg_1:ContextInfoView, _arg_2:Boolean):void
        {
            if (_arg_1)
            {
                _arg_1.hide(false);

                if (_arg_1 == _view)
                {
                    _view = null;
                };
            };
        }

        public function update(_arg_1:uint):void
        {
            if (((_view) && (_selectedObject)))
            {
                _view.update(this.handler.getObjectRectangle(_selectedObject.getId()), this.handler.getObjectScreenLocation(_selectedObject.getId()), _arg_1);
            };
        }

        public function get catalog():IHabboCatalog
        {
            return (_catalog);
        }

        private function onRoomObjectRemoved(_arg_1:RoomEngineObjectEvent):void
        {
            var _local_2:int;

            if (_arg_1.category == 10)
            {
                _local_2 = _arg_1.objectId;

                if (((!(_selectedObject == null)) && (_selectedObject.getId() == _local_2)))
                {
                    removeView(_view, false);
                    removePlantSeedConfirmationView();
                    _component.removeUpdateReceiver(this);
                    _selectedObject = null;
                };
            };
        }

        public function get friendList():IHabboFriendList
        {
            return (null);
        }

    }
}
