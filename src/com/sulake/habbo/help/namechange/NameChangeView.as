package com.sulake.habbo.help.namechange
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.INameChangeUI;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components._SafeStr_101;
    import com.sulake.core.window.components.ITextWindow;
    import flash.external.ExternalInterface;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.avatar.ChangeUserNameResultMessageEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

    public class NameChangeView implements IDisposable 
    {

        private static const NAME_UPDATE_FUNCTION:String = "FlashExternalInterface.updateName";

        private static var NAME_SUGGESTION_BG_COLOR:uint = 13232628;
        private static var NAME_SUGGESTION_BG_COLOR_OVER:uint = 11129827;

        private var _controller:INameChangeUI;
        private var _view:IFrameWindow;
        private var _checkedName:String;
        private var _pendingName:String;
        private var _mainView:IWindowContainer;
        private var _selectionView:IWindowContainer;
        private var _confirmationView:IWindowContainer;
        private var _currentView:IWindowContainer;
        private var _waitingNameCheck:Boolean = false;
        private var _suggestionsRenderer:NameSuggestionListRenderer;
        private var _disposed:Boolean;

        public function NameChangeView(_arg_1:INameChangeUI):void
        {
            _controller = _arg_1;
        }

        public function get id():String
        {
            return ("TUI_NAME_VIEW");
        }

        public function set checkedName(_arg_1:String):void
        {
            _checkedName = _arg_1;

            if (_pendingName == _checkedName)
            {
                showConfirmationView();
                return;
            };

            setNameAvailableView();
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                disposeWindow();

                if (_suggestionsRenderer != null)
                {
                    _suggestionsRenderer.dispose();
                    _suggestionsRenderer = null;
                };

                _disposed = true;
            };
        }

        private function disposeWindow():void
        {
            _mainView = null;
            _selectionView = null;
            _confirmationView = null;
            _currentView = null;

            if (_view != null)
            {
                _view.dispose();
                _view = null;
            };
        }

        private function showView(_arg_1:IWindowContainer):void
        {
            _waitingNameCheck = false;

            if (_currentView)
            {
                _currentView.visible = false;
            };

            _currentView = _arg_1;
            _currentView.visible = true;

            if (_view)
            {
                _view.content.width = _currentView.width;
                _view.content.height = _currentView.height;
            };
        }

        public function showMainView():void
        {
            if (!_view)
            {
                _view = (_controller.buildXmlWindow("welcome_name_change") as IFrameWindow);
                _view.center();
                _view.procedure = windowEventHandler;
                _mainView = (_view.content.getChildAt(0) as IWindowContainer);
            };

            _controller.localization.registerParameter("tutorial.name_change.current", "name", _controller.myName);
            _view.caption = _controller.localization.getLocalization("tutorial.name_change.title.main");
            showView(_mainView);
        }

        private function showSelectionView():void
        {
            if (!_selectionView)
            {
                _selectionView = (_controller.buildXmlWindow("welcome_name_selection") as IWindowContainer);

                if (!_selectionView)
                {
                    return;
                };

                _view.content.addChild(_selectionView);
            };

            _view.caption = _controller.localization.getLocalization("tutorial.name_change.title.select");

            var _local_1:_SafeStr_101 = (_view.findChildByName("select_name_button") as _SafeStr_101);

            if (_local_1)
            {
                _local_1.disable();
            };

            setNormalView();
            showView(_selectionView);
        }

        private function showConfirmationView():void
        {
            if (!_confirmationView)
            {
                _confirmationView = (_controller.buildXmlWindow("welcome_name_confirmation") as IWindowContainer);

                if (!_confirmationView)
                {
                    return;
                };

                _view.content.addChild(_confirmationView);
            };

            _view.caption = _controller.localization.getLocalization("tutorial.name_change.title.confirm");

            var _local_1:ITextWindow = (_confirmationView.findChildByName("final_name") as ITextWindow);

            if (_local_1)
            {
                _local_1.text = _checkedName;
            };

            showView(_confirmationView);

            if (ExternalInterface.available)
            {
                ExternalInterface.call("FlashExternalInterface.updateName", _checkedName);
            };
        }

        public function get view():IWindowContainer
        {
            return (_view);
        }

        public function setNormalView():void
        {
            if (_view == null)
            {
                return;
            };

            var _local_2:ITextWindow = (_view.findChildByName("info_text") as ITextWindow);

            if (_local_2 == null)
            {
                return;
            };

            _local_2.text = _controller.localization.getLocalization("help.tutorial.name.info");

            var _local_1:IWindowContainer = (_view.findChildByName("suggestions") as IWindowContainer);

            if (_local_1 == null)
            {
                return;
            };

            _local_1.visible = false;
        }

        public function setNameAvailableView():void
        {
            if (_view == null)
            {
                return;
            };

            nameCheckWaitEnd(true);

            var _local_2:ITextWindow = (_view.findChildByName("info_text") as ITextWindow);

            if (_local_2 == null)
            {
                return;
            };

            _controller.localization.registerParameter("help.tutorial.name.available", "name", _checkedName);
            _local_2.text = _controller.localization.getLocalization("help.tutorial.name.available");

            var _local_3:ITextFieldWindow = (_view.findChildByName("input") as ITextFieldWindow);

            if (_local_3 == null)
            {
                return;
            };

            _local_3.text = _checkedName;

            var _local_1:IWindowContainer = (_view.findChildByName("suggestions") as IWindowContainer);

            if (_local_1 == null)
            {
                return;
            };

            _local_1.visible = false;
        }

        public function setNameNotAvailableView(_arg_1:int, _arg_2:String, _arg_3:Array):void
        {
            var _local_8:int;
            var _local_6:IWindow;
            nameCheckWaitEnd(false);

            if (_currentView != _selectionView)
            {
                showSelectionView();
            };

            _pendingName = null;
            _checkedName = null;

            if (_view == null)
            {
                return;
            };

            var _local_5:ITextWindow = (_view.findChildByName("info_text") as ITextWindow);

            if (_local_5 == null)
            {
                return;
            };

            switch (_arg_1)
            {
                case ChangeUserNameResultMessageEvent._SafeStr_633:
                    _controller.localization.registerParameter("help.tutorial.name.taken", "name", _arg_2);
                    _local_5.text = _controller.localization.getLocalization("help.tutorial.name.taken");
                    break;
                case ChangeUserNameResultMessageEvent._SafeStr_634:
                    _controller.localization.registerParameter("help.tutorial.name.invalid", "name", _arg_2);
                    _local_5.text = _controller.localization.getLocalization("help.tutorial.name.invalid");
                    break;
                case ChangeUserNameResultMessageEvent._SafeStr_635:
                    break;
                case ChangeUserNameResultMessageEvent._SafeStr_636:
                    _local_5.text = _controller.localization.getLocalization("help.tutorial.name.long");
                    break;
                case ChangeUserNameResultMessageEvent._SafeStr_637:
                    _local_5.text = _controller.localization.getLocalization("help.tutorial.name.short");
                    break;
                case ChangeUserNameResultMessageEvent._SafeStr_638:
                    _local_5.text = _controller.localization.getLocalization("help.tutorial.name.change_not_allowed");
                    break;
                case ChangeUserNameResultMessageEvent._SafeStr_639:
                    _local_5.text = _controller.localization.getLocalization("help.tutorial.name.merge_hotel_down");
            };

            var _local_4:IWindowContainer = (_view.findChildByName("suggestions") as IWindowContainer);

            if (_local_4 == null)
            {
                return;
            };

            if (((_arg_1 == ChangeUserNameResultMessageEvent._SafeStr_639) || (_arg_1 == ChangeUserNameResultMessageEvent._SafeStr_638)))
            {
                _local_4.visible = false;
                return;
            };

            _local_4.visible = true;
            _suggestionsRenderer = new NameSuggestionListRenderer(_controller);

            var _local_7:int = _suggestionsRenderer.render(_arg_3, _local_4);
            _local_8 = 0;

            while (_local_8 < _local_4.numChildren)
            {
                _local_6 = _local_4.getChildAt(_local_8);
                _local_6.color = NAME_SUGGESTION_BG_COLOR;
                _local_6.addEventListener("WME_CLICK", nameSelected);
                _local_6.addEventListener("WME_OVER", nameOver);
                _local_6.addEventListener("WME_OUT", nameOut);
                _local_8++;
            };
        }

        private function nameSelected(_arg_1:WindowMouseEvent):void
        {
            nameCheckWaitEnd(true);

            var _local_4:ITextWindow = (_arg_1.target as ITextWindow);

            if (!_local_4)
            {
                return;
            };

            var _local_3:String = _local_4.text;
            setNormalView();

            var _local_2:ITextFieldWindow = (_view.findChildByName("input") as ITextFieldWindow);

            if (_local_2 == null)
            {
                return;
            };

            _local_2.text = _local_3;
        }

        private function nameOver(_arg_1:WindowMouseEvent):void
        {
            var _local_2:ITextWindow = (_arg_1.target as ITextWindow);

            if (_local_2 != null)
            {
                _local_2.color = NAME_SUGGESTION_BG_COLOR_OVER;
            };
        }

        private function nameOut(_arg_1:WindowMouseEvent):void
        {
            var _local_2:ITextWindow = (_arg_1.target as ITextWindow);

            if (_local_2 != null)
            {
                _local_2.color = NAME_SUGGESTION_BG_COLOR;
            };
        }

        public function nameCheckWaitBegin():void
        {
            var _local_1:IWindow;

            if (((_view) && (!(_view.disposed))))
            {
                _local_1 = _view.findChildByName("select_name_button");

                if (_local_1)
                {
                    _local_1.disable();
                };

                _local_1 = _view.findChildByName("check_name_button");

                if (_local_1)
                {
                    _local_1.disable();
                };

                _local_1 = _view.findChildByName("input");

                if (_local_1)
                {
                    _local_1.disable();
                };

                _local_1 = _view.findChildByName("info_text");

                if (_local_1)
                {
                    _local_1.caption = _controller.localization.getLocalization("help.tutorial.name.wait_while_checking");
                };
            };

            _waitingNameCheck = true;
        }

        public function nameCheckWaitEnd(_arg_1:Boolean):void
        {
            var _local_2:IWindow;

            if (((_view) && (!(_view.disposed))))
            {
                if (_arg_1)
                {
                    _local_2 = _view.findChildByName("select_name_button");

                    if (_local_2)
                    {
                        _local_2.enable();
                    };
                };

                _local_2 = _view.findChildByName("check_name_button");

                if (_local_2)
                {
                    _local_2.enable();
                };

                _local_2 = _view.findChildByName("input");

                if (_local_2)
                {
                    _local_2.enable();
                };
            };

            _waitingNameCheck = false;
        }

        private function windowEventHandler(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:IWindow;
            var _local_4:ITextFieldWindow;
            var _local_5:String;

            if (!_waitingNameCheck)
            {
                if (_arg_1.type == "WE_CHANGE")
                {
                    if (_arg_2.name == "input")
                    {
                        _local_3 = _view.findChildByName("select_name_button");
                        _local_4 = (_arg_2 as ITextFieldWindow);

                        if (((_local_3) && (_local_4)))
                        {
                            if (_local_4.text.length > 2)
                            {
                                _local_3.enable();
                            }

                            else
                            {
                                _local_3.disable();
                            };
                        };
                    };
                };
            };

            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            switch (_arg_2.name)
            {
                case "change_name_button":
                    showSelectionView();
                    return;
                case "keep_name_button":
                    _checkedName = _controller.myName;
                    showConfirmationView();
                    return;
                case "check_name_button":
                    _controller.checkName(getName());
                    nameCheckWaitBegin();
                    return;
                case "select_name_button":
                    _local_5 = getName();

                    if (_local_5.length < 1)
                    {
                        return;
                    };

                    if (_checkedName != _local_5)
                    {
                        _pendingName = _local_5;
                        _controller.checkName(_local_5);
                        nameCheckWaitBegin();
                    }

                    else
                    {
                        showConfirmationView();
                    };

                    return;
                case "cancel_selection_button":
                    _controller.hideView();
                    return;
                case "confirm_name_button":
                    _controller.changeName(_checkedName);
                    return;
                case "cancel_confirmation_button":
                    _controller.hideView();
                    return;
                case "header_button_close":
                    _controller.hideView();
                    return;
            };
        }

        private function getName():String
        {
            var _local_1:ITextFieldWindow;

            if (_view)
            {
                _local_1 = (_view.findChildByName("input") as ITextFieldWindow);

                if (_local_1)
                {
                    return (_local_1.text);
                };
            };

            return (null);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

    }
}
