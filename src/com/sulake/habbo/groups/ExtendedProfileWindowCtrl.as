package com.sulake.habbo.groups
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.users.ExtendedProfileData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.friendlist.RelationshipStatusEnum;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupEntryData;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetRelationshipStatusInfoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetSelectedBadgesMessageComposer;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.communication.messages.incoming.users.RelationshipStatusInfo;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsData;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.SelectFavouriteHabboGroupMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.DeselectFavouriteHabboGroupMessageComposer;
    import com.sulake.habbo.window.utils.IAlertDialog;

    public class ExtendedProfileWindowCtrl implements IDisposable 
    {

        private var _manager:HabboGroupsManager;
        private var _window:IWindowContainer;
        private var _groupsList:IItemListWindow;
        private var _groupsListEntryTemplate:IWindowContainer;
        private var _selectedGroupId:int;
        private var _groupDetailsCtrl:GroupDetailsCtrl;
        private var _noGroupsContainer:IWindowContainer;
        private var _data:ExtendedProfileData;
        private var _updateExpected:Boolean;
        private var _badgeUpdateExpected:Boolean = false;
        private var _relationshipStatusMap:Map = new Map();
        private var _relationshipUpdateExpected:Boolean = false;

        public function ExtendedProfileWindowCtrl(_arg_1:HabboGroupsManager)
        {
            _manager = _arg_1;
            _groupDetailsCtrl = new GroupDetailsCtrl(_arg_1, false);
        }

        public function dispose():void
        {
            _manager = null;
            _groupsList = null;
            _data = null;

            if (_relationshipStatusMap)
            {
                _relationshipStatusMap.dispose();
                _relationshipStatusMap = null;
            };

            if (_window)
            {
                _window.dispose();
                _window = null;
            };

            if (_groupDetailsCtrl)
            {
                _groupDetailsCtrl.dispose();
                _groupDetailsCtrl = null;
            };
        }

        public function get disposed():Boolean
        {
            return (_manager == null);
        }

        private function prepareWindow():void
        {
            if (_window != null)
            {
                return;
            };

            if (_groupsListEntryTemplate == null)
            {
                _groupsListEntryTemplate = IWindowContainer(_manager.getXmlWindow("group_entry"));
            };

            if (_noGroupsContainer == null)
            {
                _noGroupsContainer = IWindowContainer(_manager.getXmlWindow("no_groups"));
                _noGroupsContainer.findChildByName("view_groups_button").procedure = onViewGroups;
            };

            _window = IFrameWindow(_manager.getXmlWindow("new_extended_profile"));
            _window.findChildByTag("close").procedure = onClose;
            _window.findChildByName("addasfriend_button").procedure = onAddAsFriend;
            _window.findChildByName("rooms_button").procedure = onRooms;
            _groupsList = IItemListWindow(_window.findChildByName("groups_list"));
            _window.center();
            _window.findChildByName("change_looks").procedure = onChangeLooks;
            _window.findChildByName("change_badges").procedure = onChangeBadges;
            _window.findChildByName("user_activity_points").visible = _manager.isActivityDisplayEnabled;

            for each (var _local_1:int in RelationshipStatusEnum.displayableStatuses)
            {
                _window.findChildByName((RelationshipStatusEnum.statusAsString(_local_1) + "_friend_name_link_region")).procedure = onRelationshipLink;
            };
        }

        public function onProfileChanged(_arg_1:int):void
        {
            if (((((!(_data == null)) && (_data.userId == _arg_1)) && (!(_window == null))) && (_window.visible)))
            {
                _manager.send(new GetExtendedProfileMessageComposer(_arg_1));
                _updateExpected = true;
            };
        }

        public function onProfile(_arg_1:ExtendedProfileData):void
        {
            _data = _arg_1;

            var _local_2:HabboGroupEntryData = getSelectedGroup();

            if (_local_2 == null)
            {
                if (_data.guilds.length > 0)
                {
                    _selectedGroupId = _data.guilds[0].groupId;
                    _local_2 = _data.guilds[0];
                }

                else
                {
                    _selectedGroupId = 0;
                };
            };

            if (_selectedGroupId > 0)
            {
                _manager.send(new GetHabboGroupDetailsMessageComposer(_selectedGroupId, false));
            };

            refresh();
            _window.visible = true;

            if (!_updateExpected)
            {
                _window.activate();
            };

            _updateExpected = false;
        }

        private function getSelectedGroup():HabboGroupEntryData
        {
            for each (var _local_1:HabboGroupEntryData in _data.guilds)
            {
                if (_local_1.groupId == _selectedGroupId)
                {
                    return (_local_1);
                };
            };

            return (null);
        }

        private function refresh():void
        {
            _manager.send(new GetRelationshipStatusInfoMessageComposer(_data.userId));
            _manager.send(new GetSelectedBadgesMessageComposer(_data.userId));
            prepareWindow();
            refreshHeader();
            refreshGroupList();
        }

        private function refreshGroupList():void
        {
            var _local_1:IWindowContainer;
            var _local_2:IBadgeImageWidget;
            var _local_4:IWindowContainer;
            var _local_3:Boolean = (_data.userId == _manager.avatarId);
            _groupsList.visible = (_data.guilds.length > 0);
            _groupsList.destroyListItems();

            for each (var _local_5:HabboGroupEntryData in _data.guilds)
            {
                _local_1 = IWindowContainer(_groupsListEntryTemplate.clone());
                _local_1.id = _local_5.groupId;
                _local_1.findChildByName("bg_region").procedure = onSelectGroup;
                _local_1.findChildByName("bg_region").id = _local_5.groupId;
                _local_1.findChildByName("clear_favourite").procedure = onClearFavourite;
                _local_1.findChildByName("clear_favourite").visible = ((_local_5.favourite) && (_local_3));
                _local_1.findChildByName("clear_favourite").id = _local_5.groupId;
                _local_1.findChildByName("make_favourite").procedure = onMakeFavourite;
                _local_1.findChildByName("make_favourite").visible = ((!(_local_5.favourite)) && (_local_3));
                _local_1.findChildByName("make_favourite").id = _local_5.groupId;
                _local_2 = IBadgeImageWidget(IWidgetWindow(_local_1.findChildByName("group_pic_bitmap")).widget);
                _local_2.type = "group";
                _local_2.badgeId = _local_5.badgeCode;
                _local_2.groupId = _local_5.groupId;
                _groupsList.addListItem(_local_1);
            };

            refreshGroupListSelection();
            _manager.localization.registerParameter("extendedprofile.groups.count", "count", _data.guilds.length.toString());

            if (_data.guilds.length < 1)
            {
                _local_4 = IWindowContainer(_window.findChildByName("group_cont"));
                _local_4.removeChildAt(0);
                _local_4.addChild(_noGroupsContainer);
                _noGroupsContainer.findChildByName("no_groups_caption").caption = _manager.localization.getLocalization(((_local_3) ? "extendedprofile.nogroups.me" : "extendedprofile.nogroups.user"));
                _noGroupsContainer.findChildByName("view_groups_button").visible = true;
            };
        }

        private function refreshGroupListSelection():void
        {
            var _local_2:int;
            var _local_1:IWindowContainer;
            _local_2 = 0;

            while (_local_2 < _groupsList.numListItems)
            {
                _local_1 = IWindowContainer(_groupsList.getListItemAt(_local_2));
                _local_1.findChildByName("bg_selected_bitmap").visible = (_selectedGroupId == _local_1.id);
                _local_1.findChildByName("bg_unselected_bitmap").visible = (!(_selectedGroupId == _local_1.id));
                _local_2++;
            };
        }

        private function refreshHeader():void
        {
            var _local_1:Boolean = (_data.userId == _manager.avatarId);
            _window.findChildByName("motto_txt").caption = _data.motto;
            _window.findChildByName("status_txt").visible = ((_data.isFriend) || (_local_1));
            _window.findChildByName("friend_request_sent_txt").visible = _data.isFriendRequestSent;
            _window.findChildByName("offline_icon").visible = (!(_data.isOnline));
            _window.findChildByName("online_icon").visible = _data.isOnline;
            _window.findChildByName("status").invalidate();
            _manager.localization.registerParameter("extendedprofile.username", "username", _data.userName);
            _manager.localization.registerParameter("extendedprofile.created", "created", _data.creationDate);
            _manager.localization.registerParameter("extendedprofile.activitypoints", "activitypoints", _data.achievementScore.toString());
            _manager.localization.registerParameter("extendedprofile.last.login", "lastlogin", FriendlyTime.getFriendlyTime(_manager.localization, _data.lastAccessSinceInSeconds, ".ago"));
            _window.findChildByName("user_last_login").visible = (_data.lastAccessSinceInSeconds > -1);
            refreshAvatarImage();

            var _local_2:Boolean = (_data.friendCount > -1);
            var _local_3:Boolean = (((_data.isFriend) && (_local_2)) || (_local_1));
            _window.findChildByName("addasfriend_button").visible = (((((!(_data.isFriend)) && (!(_data.isFriendRequestSent))) && (!(_local_1))) && (_manager.friendlist.canBeAskedForAFriend(_data.userId))) && (_local_2));
            _window.findChildByName("ok_icon").visible = _local_3;
            _window.findChildByName("status_txt").visible = _local_3;
            _window.findChildByName("top_right").visible = _local_2;
            _window.findChildByName("status_txt").caption = _manager.localization.getLocalization(((_data.isFriend) ? "extendedprofile.friend" : "extendedprofile.me"));
            _window.findChildByName("change_own_attributes").visible = _local_1;
            _window.findChildByName("levelValue").caption = _data.accountLevel.toString();
            _window.findChildByName("starGemCount").caption = _data.starGemCount.toString();
        }

        private function refreshRelationships():void
        {
            var _local_1:Boolean = _manager.getBoolean("relationship.status.enabled");

            if (((_local_1) && (_window)))
            {
                _window.findChildByName("rel_status_label_txt").visible = true;

                for each (var _local_2:int in RelationshipStatusEnum.displayableStatuses)
                {
                    setRelationshipDetails(_local_2);
                };
            };

            _manager.localization.registerParameter("extendedprofile.friends.count", "count", _data.friendCount.toString());
        }

        private function setRelationshipDetails(_arg_1:int):void
        {
            var _local_4:RelationshipStatusInfo = _relationshipStatusMap.getValue(_arg_1);
            var _local_5:String = RelationshipStatusEnum.statusAsString(_arg_1);
            var _local_6:IWindow = _window.findChildByName((_local_5 + "_txt"));
            var _local_3:IWindow = _window.findChildByName((_local_5 + "_friend_name_link_text"));
            var _local_2:IWidgetWindow = IWidgetWindow(_window.findChildByName((_local_5 + "_head")));

            if (((_local_4) && (_local_4.friendCount > 0)))
            {
                _local_3.caption = _local_4.randomFriendName;
                _local_2.visible = true;
                IAvatarImageWidget(_local_2.widget).figure = _local_4.randomFriendFigure;

                if (_local_4.friendCount > 1)
                {
                    _local_6.visible = true;
                    _local_6.invalidate();
                    _local_6.caption = _manager.localization.getLocalizationWithParams(("extendedprofile.relstatus.others." + _local_5), "", "count", ("" + (_local_4.friendCount - 1)));
                }

                else
                {
                    _local_6.visible = false;
                };
            }

            else
            {
                _local_2.visible = false;
                _local_3.caption = "${extendedprofile.add.friends}";
                _local_6.caption = "${extendedprofile.no.friends.in.this.category}";
                _local_6.visible = true;
            };
        }

        public function onGroupDetails(_arg_1:HabboGroupDetailsData):void
        {
            var _local_2:IWindowContainer;

            if (_selectedGroupId == _arg_1.groupId)
            {
                _local_2 = IWindowContainer(_window.findChildByName("group_cont"));
                _local_2.removeChildAt(0);
                _local_2.invalidate();
                _groupDetailsCtrl.onGroupDetails(_local_2, _arg_1);
            };
        }

        public function onRelationshipStatusInfo(_arg_1:int, _arg_2:Map):void
        {
            if (((_data) && (relationshipUpdateExpected)))
            {
                _relationshipStatusMap = _arg_2.clone();
                refreshRelationships();
                relationshipUpdateExpected = false;
            };
        }

        public function onUserBadges(_arg_1:int, _arg_2:Array):void
        {
            var _local_4:int;
            var _local_3:IBadgeImageWidget;

            if ((((_data) && (badgeUpdateExpected)) && (!(_window == null))))
            {
                _local_4 = 0;

                while (_local_4 < 5)
                {
                    _local_3 = IBadgeImageWidget(IWidgetWindow(_window.findChildByName(("badge_" + _local_4))).widget);
                    _local_3.type = "normal";
                    _local_3.badgeId = ((_local_4 < _arg_2.length) ? _arg_2[_local_4] : "");
                    _local_4++;
                };

                badgeUpdateExpected = false;
            };
        }

        private function setProc(_arg_1:String, _arg_2:Function):void
        {
            var _local_3:IWindow = _window.findChildByName(_arg_1);
            _local_3.mouseThreshold = 0;
            _local_3.procedure = _arg_2;
        }

        private function onAddAsFriend(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _manager.friendlist.askForAFriend(_data.userId, _data.userName);
            _data.isFriendRequestSent = true;
            refresh();
        }

        private function onRooms(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _manager.newNavigator.performSearch("hotel_view", ("owner:" + _data.userName));
        }

        private function onRelationshipLink(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_4:String;
            var _local_3:RelationshipStatusInfo;
            var _local_5:int;

            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            if ((((!(_arg_1.target == null)) && (!(_arg_2.name == null))) && (!(_relationshipStatusMap == null))))
            {
                _local_4 = _arg_2.name.substr(0, _arg_2.name.indexOf("_"));
                _local_3 = _relationshipStatusMap.getValue(RelationshipStatusEnum.stringAsStatus(_local_4));

                if (_local_3 != null)
                {
                    _local_5 = _local_3.randomFriendId;

                    if (_local_5)
                    {
                        _manager.showExtendedProfile(_local_5);
                    };
                }

                else
                {
                    _manager.windowManager.alert("${extendedprofile.add.friends.alert.title}", "${extendedprofile.add.friends.alert.body}", 0, addFriendsAlertCallback);
                };
            };
        }

        private function onViewGroups(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _manager.navigator.performGuildBaseSearch();
        }

        private function onSelectGroup(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _selectedGroupId = _arg_2.id;
            _manager.send(new GetHabboGroupDetailsMessageComposer(_selectedGroupId, false));
            _manager.send(new EventLogMessageComposer("HabboGroups", ("" + _arg_2.id), "select"));
            this.refreshGroupListSelection();
        }

        private function onMakeFavourite(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _manager.send(new SelectFavouriteHabboGroupMessageComposer(_arg_2.id));
            _manager.send(new EventLogMessageComposer("HabboGroups", ("" + _arg_2.parent.id), "make favourite"));
            _selectedGroupId = _arg_2.id;
        }

        private function onClearFavourite(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _manager.send(new DeselectFavouriteHabboGroupMessageComposer(_arg_2.id));
            _manager.send(new EventLogMessageComposer("HabboGroups", ("" + _arg_2.parent.id), "clear favourite"));
            _selectedGroupId = _arg_2.id;
        }

        private function onClose(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            close();
        }

        private function onChangeLooks(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _manager.context.createLinkEvent("avatareditor/open");
        }

        private function onChangeBadges(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _manager.context.createLinkEvent("inventory/open/badges");
        }

        public function close():void
        {
            if (_window != null)
            {
                _window.visible = false;
            };
        }

        private function refreshAvatarImage(_arg_1:Boolean=false):void
        {
            var _local_2:IWidgetWindow = IWidgetWindow(_window.findChildByName("avatar_image"));
            var _local_3:IAvatarImageWidget = IAvatarImageWidget(_local_2.widget);
            _local_3.figure = _data.figure;
        }

        public function updateVisibleExtendedProfile(_arg_1:int):void
        {
            if (((((!(_window == null)) && (_window.visible)) && (!(_data == null))) && (!(_data.userId == _arg_1))))
            {
                _manager.send(new GetExtendedProfileMessageComposer(_arg_1));
            };
        }

        public function get badgeUpdateExpected():Boolean
        {
            return (_badgeUpdateExpected);
        }

        public function set badgeUpdateExpected(_arg_1:Boolean):void
        {
            _badgeUpdateExpected = _arg_1;
        }

        public function set relationshipUpdateExpected(_arg_1:Boolean):void
        {
            _relationshipUpdateExpected = _arg_1;
        }

        public function get relationshipUpdateExpected():Boolean
        {
            return (_relationshipUpdateExpected);
        }

        private function addFriendsAlertCallback(_arg_1:IAlertDialog, _arg_2:WindowEvent):void
        {
            if (_arg_2.type == "WE_OK")
            {
                _manager.context.createLinkEvent("friendbar/findfriends");
                close();
            };

            _arg_1.dispose();
        }

    }
}
