package com.sulake.habbo.navigator.view.search.results
{
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import __AS3__.vec.Vector;

    public class CategoryElementFactory
    {

        private static const MARGIN_LAYOUT_CATEGORY_CONTAINER:int = 13;

        private var _navigator:HabboNewNavigator;
        private var _blockResultsView:BlockResultsView;
        private var _roomEntryElementFactory:RoomEntryElementFactory;
        private var _categoryTemplate:IWindowContainer;
        private var _collapsedCategoryTemplate:IWindowContainer;
        private var _noResultsTemplate:IWindowContainer;

        public function CategoryElementFactory(_arg_1:HabboNewNavigator, _arg_2:RoomEntryElementFactory)
        {
            _navigator = _arg_1;
            _roomEntryElementFactory = _arg_2;
        }

        public function set blockResultsView(_arg_1:BlockResultsView):void
        {
            _blockResultsView = _arg_1;
        }

        public function set categoryTemplate(_arg_1:IWindowContainer):void
        {
            _categoryTemplate = _arg_1;
        }

        public function set collapsedCategoryTemplate(_arg_1:IWindowContainer):void
        {
            _collapsedCategoryTemplate = _arg_1;
        }

        public function set noResultsTemplate(_arg_1:IWindowContainer):void
        {
            _noResultsTemplate = _arg_1;
        }

        public function getOpenCategoryElement(_arg_1:Vector.<GuestRoomData>, _arg_2:String, _arg_3:int=-1, _arg_4:int=0, _arg_5:int=-1):IWindowContainer
        {
            var guestRooms:Vector.<GuestRoomData> = _arg_1;
            var title:String = _arg_2;
            var showMoreId:int = _arg_3;
            var actionAllowed:int = _arg_4;
            var resultMode:int = _arg_5;
            var container:IWindowContainer = IWindowContainer(_categoryTemplate.clone());
            container.width = (_blockResultsView.itemListWidth - 13);
            container.height = (16 + (_roomEntryElementFactory.rowEntryTemplateHeight * (guestRooms.length + 1)));
            container.findChildByName("category_name").caption = title;
            container.findChildByName("category_back").addEventListener("WME_CLICK", _blockResultsView.onCategoryBackClicked);
            container.findChildByName("category_back").visible = (actionAllowed == 2);
            container.findChildByName("category_collapse").visible = (!(actionAllowed == 2));
            container.findChildByName("category_collapse").id = showMoreId;
            container.findChildByName("category_collapse").addEventListener("WME_CLICK", _blockResultsView.onCategoryCollapseClicked);
            container.findChildByName("category_name_region").id = showMoreId;
            container.findChildByName("category_name_region").addEventListener("WME_CLICK", _blockResultsView.onCategoryCollapseClicked);
            container.findChildByName("category_show_more").id = showMoreId;
            container.findChildByName("category_show_more").addEventListener("WME_CLICK", _blockResultsView.onCategoryShowMoreClicked);
            container.findChildByName("category_show_more").visible = (actionAllowed == 1);
            container.findChildByName("category_add_quick_link").id = showMoreId;
            container.findChildByName("category_add_quick_link").addEventListener("WME_CLICK", _blockResultsView.onCategoryAddQuickLinkClicked);
            container.findChildByName("category_content_background").background = true;
            container.findChildByName("category_content_background").height = (12 + (_roomEntryElementFactory.rowEntryTemplateHeight * (guestRooms.length + 1)));
            container.findChildByName("category_add_quick_link").visible = (_navigator.currentResults.searchCodeOriginal.indexOf("official_view") == -1);

            var headerControls:IItemListWindow = IItemListWindow(container.findChildByName("category_controls_itemlist"));

            if (_navigator.sessionData.isPerkAllowed("NAVIGATOR_ROOM_THUMBNAIL_CAMERA"))
            {
                headerControls.getListItemByName("category_toggle_tiles").addEventListener("WME_CLICK", _blockResultsView.onCategoryToggleModeClicked);
                headerControls.getListItemByName("category_toggle_tiles").id = showMoreId;
                headerControls.getListItemByName("category_toggle_tiles").visible = (resultMode == 0);
                headerControls.getListItemByName("category_toggle_rows").addEventListener("WME_CLICK", _blockResultsView.onCategoryToggleModeClicked);
                headerControls.getListItemByName("category_toggle_rows").id = showMoreId;
                headerControls.getListItemByName("category_toggle_rows").visible = (resultMode == 1);
            }

            else
            {
                headerControls.removeListItem(headerControls.getListItemByName("category_toggle_tiles"));
                headerControls.removeListItem(headerControls.getListItemByName("category_toggle_rows"));
            };

            headerControls.arrangeListItems();

            var roomList:IItemListWindow = IItemListWindow(container.findChildByName("category_content"));

            if (resultMode == 0)
            {
                roomList.spacing = 0;
            };

            var colorMod:uint = 9412607;
            var color:int = -1;
            var colorModAccumulator:int = 1;
            var currentTileContainer:IItemListWindow;

            for each (var guestRoom:GuestRoomData in guestRooms)
            {
                var alternatingColor:int = (((colorModAccumulator % 2) == 0) ? color : colorMod);

                if (resultMode == 0)
                {
                    roomList.addListItem(_roomEntryElementFactory.getNewRowElement(guestRoom, alternatingColor));
                    colorModAccumulator++;
                }

                else
                {
                    if (!currentTileContainer)
                    {
                        currentTileContainer = _roomEntryElementFactory.getNewTileContainerElement();
                        roomList.addListItem(currentTileContainer);
                    };

                    currentTileContainer.addEventListener("WME_WHEEL", function (_arg_1:WindowMouseEvent):void
                    {
                        _blockResultsView.itemList.scrollV = (_blockResultsView.itemList.scrollV - (_arg_1.delta * 0.01));
                    });
                    currentTileContainer.addListItem(_roomEntryElementFactory.getNewTileElement(guestRoom, alternatingColor));

                    if (currentTileContainer.numListItems >= 3)
                    {
                        currentTileContainer = null;
                        colorModAccumulator++;
                    };
                };
            };

            roomList.arrangeListItems();
            return (container);
        }

        public function getCollapsedCategoryElement(_arg_1:String, _arg_2:int=-1, _arg_3:int=0):IWindowContainer
        {
            var _local_4:IWindowContainer = IWindowContainer(_collapsedCategoryTemplate.clone());
            _local_4.findChildByName("category_name").caption = _arg_1;
            _local_4.findChildByName("category_show_more").id = _arg_2;
            _local_4.findChildByName("category_show_more").addEventListener("WME_CLICK", _blockResultsView.onCategoryShowMoreClicked);
            _local_4.findChildByName("category_show_more").visible = (_arg_3 == 1);
            _local_4.findChildByName("category_expand").addEventListener("WME_CLICK", _blockResultsView.onCategoryExpandClicked);
            _local_4.findChildByName("category_expand").id = _arg_2;
            _local_4.findChildByName("category_name_region").addEventListener("WME_CLICK", _blockResultsView.onCategoryExpandClicked);
            _local_4.findChildByName("category_name_region").id = _arg_2;
            _local_4.findChildByName("category_add_quick_link").addEventListener("WME_CLICK", _blockResultsView.onCategoryAddQuickLinkClicked);
            _local_4.findChildByName("category_add_quick_link").id = _arg_2;
            _local_4.findChildByName("category_add_quick_link").visible = (_navigator.currentResults.searchCodeOriginal.indexOf("official_view") == -1);
            _local_4.width = (_blockResultsView.itemListWidth - 13);
            IItemListWindow(_local_4.findChildByName("category_controls_itemlist")).arrangeListItems();
            return (_local_4);
        }

        public function getNoResultsELement():IWindowContainer
        {
            return (IWindowContainer(_noResultsTemplate.clone()));
        }

    }
}