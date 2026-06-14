package com.sulake.habbo.navigator.view.search
{
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowEvent;

    public class SearchView 
    {

        private static const INPUT_PLACEHOLDER_TEXTCOLOR:uint = 0x9F9F9F;
        private static const INPUT_TEXTCOLOR:uint = 0;

        private static var FILTER_SELECTOR_INDEX_TO_MODE:Array = [5, 2, 1, 3, 4];
        private static var FILTER_MODE_TO_SELECTOR_INDEX:Array = [0, 2, 1, 3, 4, 0];

        private var _navigator:HabboNewNavigator;
        private var _container:IWindowContainer;
        private var _inputField:ITextFieldWindow;
        private var _filterSelector:IDropMenuWindow;
        private var _inputFieldPlaceholderText:String;

        public function SearchView(_arg_1:HabboNewNavigator)
        {
            _navigator = _arg_1;
            _inputFieldPlaceholderText = _navigator.localization.getLocalizationWithParams("navigator.filter.input.placeholder", "filter rooms by...");
        }

        public function set container(_arg_1:IWindowContainer):void
        {
            _container = _arg_1;
            _filterSelector = IDropMenuWindow(_container.findChildByName("filter_type_drop_menu"));
            _inputField = ITextFieldWindow(_container.findChildByName("search_input"));
            _inputField.addEventListener("WKE_KEY_UP", keyUpHandler);
            _inputField.addEventListener("WE_CHANGE", onInputChanged);
            _inputField.addEventListener("WE_FOCUSED", onInputFocused);

            var _local_2:IWindow = _container.findChildByName("clear_search_button");

            if (_local_2)
            {
                _local_2.addEventListener("WME_CLICK", onClearSearch);
            };

            clear();
        }

        private function onClearSearch(_arg_1:WindowMouseEvent=null):void
        {
            _inputField.focus();
            _inputField.caption = "";

            var _local_2:IStaticBitmapWrapperWindow = (_container.findChildByName("search.clear.icon") as IStaticBitmapWrapperWindow);
            _local_2.assetUri = "common_small_pen";
        }

        public function clear():void
        {
            setInputToFilterPlaceHolder();
            _filterSelector.selection = 0;
            _container.findChildByName("refreshButtonContainer").visible = false;
        }

        public function setTextAndSearchModeFromFilter(_arg_1:String, _arg_2:String=""):void
        {
            var _local_4:IStaticBitmapWrapperWindow;
            var _local_3:int = _SafeStr_205.filterInInput(_arg_1);

            if (_local_3 != 0)
            {
                _filterSelector.selection = FILTER_MODE_TO_SELECTOR_INDEX[_local_3];
                _inputField.caption = _arg_1.substr(_SafeStr_205.FILTER_PREFIX[_local_3].length, (_arg_1.length - _SafeStr_205.FILTER_PREFIX[_local_3].length));
            }

            else
            {
                _inputField.caption = _arg_1;
                _filterSelector.selection = 0;
            };

            if (((!(_arg_2 == "")) && (!(_arg_2 == _inputFieldPlaceholderText))))
            {
                _inputField.caption = _arg_2;
                setInputFieldTextFormattingToPlaceholder(true);
            }

            else
            {
                if (_inputField.caption == "")
                {
                    setInputToFilterPlaceHolder();
                }

                else
                {
                    setInputFieldTextFormattingToPlaceholder(false);
                };
            };

            if (((!(_inputField.caption.length == 0)) && (!(_inputField.caption == _inputFieldPlaceholderText))))
            {
                _container.findChildByName("refreshButtonContainer").visible = true;
                _local_4 = (_container.findChildByName("search.clear.icon") as IStaticBitmapWrapperWindow);
                _local_4.assetUri = "icons_close";
            }

            else
            {
                _container.findChildByName("refreshButtonContainer").visible = false;
                _local_4 = (_container.findChildByName("search.clear.icon") as IStaticBitmapWrapperWindow);
                _local_4.assetUri = "common_small_pen";
            };
        }

        private function keyUpHandler(_arg_1:WindowKeyboardEvent):void
        {
            if (_arg_1.keyCode == 13)
            {
                _navigator.performSearch(_navigator.currentResults.searchCodeOriginal, getFilterParameter());
            };
        }

        private function getFilterParameter():String
        {
            return (_SafeStr_205.FILTER_PREFIX[FILTER_SELECTOR_INDEX_TO_MODE[_filterSelector.selection]] + _inputField.caption);
        }

        private function setInputToFilterPlaceHolder():void
        {
            setInputFieldTextFormattingToPlaceholder(true);
            _inputField.caption = _inputFieldPlaceholderText;
        }

        private function onInputFocused(_arg_1:WindowEvent):void
        {
            setInputFieldTextFormattingToPlaceholder(false);

            if (_inputField.caption == _inputFieldPlaceholderText)
            {
                _inputField.caption = "";
            };
        }

        private function setInputFieldTextFormattingToPlaceholder(_arg_1:Boolean):void
        {
            _inputField.textColor = ((_arg_1) ? 0x9F9F9F : 0);
            _inputField.italic = _arg_1;
        }

        private function onInputChanged(_arg_1:WindowEvent):void
        {
        }

        public function get currentInput():String
        {
            if (_inputField != null)
            {
                return (_inputField.caption);
            };

            return (_inputFieldPlaceholderText);
        }

    }
}
