package com.sulake.habbo.ui.widget.furniture.rentablespace
{
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.FurnitureRentableSpaceWidgetHandler;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.utils.IAlertDialog;

    public class RentableSpaceConfigWidget extends RoomWidgetBase
    {

        private static const MAX_DROPDOWN_SLOTS:int = 6;

        private var _mainWindow:IWindowContainer;
        private var _roomObject:IRoomObject;
        private var _hcRequired:Boolean = false;
        private var _currencies:Array = [];
        private var _currencyIndex:int = 0;
        private var _dropdownOpen:Boolean = false;
        private var _waitingForSaveConfirmation:Boolean = false;

        public function RentableSpaceConfigWidget(_arg_1:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            ownHandler.configWidget = this;
        }

        private function get ownHandler():FurnitureRentableSpaceWidgetHandler
        {
            return (_SafeStr_3915 as FurnitureRentableSpaceWidgetHandler);
        }

        override public function get mainWindow():IWindow
        {
            return (_mainWindow);
        }

        public function show(_arg_1:IRoomObject):void
        {
            _roomObject = _arg_1;
            ownHandler.getRentableSpaceConfig(_arg_1.getId());
        }

        public function hide():void
        {
            _dropdownOpen = false;

            if (_mainWindow != null)
            {
                _mainWindow.dispose();
                _mainWindow = null;
            }

            _roomObject = null;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }

            hide();
            super.dispose();
        }

        private function createWindow():void
        {
            if (_mainWindow != null)
            {
                return;
            }

            var xmlAsset:* = assets ? assets.getAssetByName("rentablespace_config_xml") : null;
            if (xmlAsset == null)
            {
                return;
            }

            _mainWindow = (windowManager.buildFromXML(XML(xmlAsset.content)) as IWindowContainer);
            if (_mainWindow == null)
            {
                return;
            }

            _mainWindow.procedure = windowProcedure;
            _mainWindow.center();
        }

        private function windowProcedure(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            switch (_arg_1.type)
            {
                case "WME_CLICK":
                    switch (_arg_2.name)
                    {
                        case "header_button_close":
                            hide();
                            break;
                        case "currency_dropdown_button":
                            toggleDropdown();
                            break;
                        case "requires_hc_toggle":
                            _hcRequired = !_hcRequired;
                            updateHcToggleLabel();
                            break;
                        case "save_button":
                            saveConfig();
                            break;
                        default:
                            if (_arg_2.name.indexOf("currency_opt_") == 0)
                            {
                                var idx:int = int(_arg_2.name.charAt(13));
                                if (idx < _currencies.length)
                                {
                                    _currencyIndex = idx;
                                    updateCurrencyLabel();
                                }
                                hideDropdown();
                            }
                            break;
                    }
                    return;
            }
        }

        private function toggleDropdown():void
        {
            if (_dropdownOpen)
            {
                hideDropdown();
            }
            else
            {
                showDropdown();
            }
        }

        private function showDropdown():void
        {
            if (_mainWindow == null || _currencies.length == 0)
            {
                return;
            }

            var panel:IWindowContainer = (_mainWindow.findChildByName("currency_dropdown_panel") as IWindowContainer);
            if (panel == null)
            {
                return;
            }

            var slot:IWindowContainer;
            var slotName:String;
            var isDiam:Boolean;
            var isDuck:Boolean;

            for (var i:int = 0; i < MAX_DROPDOWN_SLOTS; i++)
            {
                slot = (panel.findChildByName("currency_opt_" + i) as IWindowContainer);
                if (slot == null)
                {
                    continue;
                }
                if (i < _currencies.length)
                {
                    slot.findChildByName("currency_opt_" + i + "_label").caption = _currencies[i].name;
                    slotName = _currencies[i].name.toLowerCase();
                    isDiam = (slotName.indexOf("diamond") >= 0);
                    isDuck = (slotName.indexOf("ducket") >= 0 || slotName.indexOf("pixel") >= 0);
                    slot.findChildByName("currency_opt_" + i + "_icon_credits").visible = (!isDiam && !isDuck);
                    slot.findChildByName("currency_opt_" + i + "_icon_diamonds").visible = isDiam;
                    slot.findChildByName("currency_opt_" + i + "_icon_duckets").visible = isDuck;
                    slot.visible = true;
                }
                else
                {
                    slot.visible = false;
                }
            }

            var _dur:IWindow = _mainWindow.findChildByName("duration_input");
            if (_dur != null)
            {
                _dur.visible = false;
            }

            panel.visible = true;
            _dropdownOpen = true;
        }

        private function hideDropdown():void
        {
            if (_mainWindow == null)
            {
                return;
            }

            var panel:IWindow = _mainWindow.findChildByName("currency_dropdown_panel");
            if (panel != null)
            {
                panel.visible = false;
            }

            var _dur:IWindow = _mainWindow.findChildByName("duration_input");
            if (_dur != null)
            {
                _dur.visible = true;
            }

            _dropdownOpen = false;
        }

        private function updateCurrencyLabel():void
        {
            if (_mainWindow == null || _currencies.length == 0)
            {
                return;
            }

            var _name:String = _currencies[_currencyIndex].name;
            _mainWindow.findChildByName("currency_label").caption = _name;

            var _nameLower:String = _name.toLowerCase();
            var _isDiam:Boolean = (_nameLower.indexOf("diamond") >= 0);
            var _isDuck:Boolean = (_nameLower.indexOf("ducket") >= 0 || _nameLower.indexOf("pixel") >= 0);
            _mainWindow.findChildByName("dropdown_sel_icon_credits").visible = (!_isDiam && !_isDuck);
            _mainWindow.findChildByName("dropdown_sel_icon_diamonds").visible = _isDiam;
            _mainWindow.findChildByName("dropdown_sel_icon_duckets").visible = _isDuck;
        }

        private function updateHcToggleLabel():void
        {
            if (_mainWindow == null)
            {
                return;
            }

            _mainWindow.findChildByName("requires_hc_label").caption = _hcRequired
                ? "${rentablespace.config.yes}"
                : "${rentablespace.config.no}";
        }

        private function saveConfig():void
        {
            if (_roomObject == null || _mainWindow == null)
            {
                return;
            }

            if (_currencies.length == 0)
            {
                return;
            }

            var price:int = int(_mainWindow.findChildByName("price_input").caption);
            var rentDurationSeconds:int = int(_mainWindow.findChildByName("duration_input").caption);

            if (price < 0 || rentDurationSeconds <= 0)
            {
                return;
            }

            var currencyTypeId:int = _currencies[_currencyIndex].id;

            _waitingForSaveConfirmation = true;
            ownHandler.configureRentableSpace(
                _roomObject.getId(), price, currencyTypeId, rentDurationSeconds, _hcRequired
            );
        }

        public function populateConfig(_isConfigured:Boolean, _price:int, _currencyTypeId:int, _rentDurationSeconds:int, _requiresHc:Boolean, _newCurrencies:Array):void
        {
            if (_roomObject == null)
            {
                return;
            }

            // Save echo: close window and show brief confirmation.
            if (_waitingForSaveConfirmation)
            {
                _waitingForSaveConfirmation = false;
                showSaveConfirmation();
                return;
            }

            // Update currency list only when server sends them (initial GetConfig).
            if (_newCurrencies != null && _newCurrencies.length > 0)
            {
                _currencies = _newCurrencies;
                _currencyIndex = 0;

                for (var i:int = 0; i < _currencies.length; i++)
                {
                    if (_currencies[i].id == _currencyTypeId)
                    {
                        _currencyIndex = i;
                        break;
                    }
                }
            }

            createWindow();
            if (_mainWindow == null)
            {
                return;
            }

            _hcRequired = _requiresHc;
            hideDropdown();
            _mainWindow.findChildByName("price_input").caption = _price.toString();
            _mainWindow.findChildByName("duration_input").caption = _rentDurationSeconds.toString();
            updateCurrencyLabel();
            updateHcToggleLabel();

            if (!_mainWindow.visible)
            {
                _mainWindow.visible = true;
            }
        }

        private function showSaveConfirmation():void
        {
            hide();

            windowManager.alert(
                "${rentablespace.config.widget.title}",
                "${rentablespace.config.saved}",
                0,
                function(_dlg:IAlertDialog, _evt:WindowEvent):void
                {
                    _dlg.dispose();
                }
            );
        }

    }
}
