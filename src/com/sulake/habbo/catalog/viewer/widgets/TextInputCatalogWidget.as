package com.sulake.habbo.catalog.viewer.widgets
{
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.TextInputEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;

    public class TextInputCatalogWidget extends CatalogWidget implements ICatalogWidget 
    {

        private var _inputText:ITextFieldWindow;

        public function TextInputCatalogWidget(_arg_1:IWindowContainer)
        {
            super(_arg_1);
        }

        override public function init():Boolean
        {
            if (!super.init())
            {
                return (false);
            };

            _inputText = (_window.findChildByName("input_text") as ITextFieldWindow);

            if (_inputText != null)
            {
                _inputText.addEventListener("WKE_KEY_UP", onKey);
            };

            return (true);
        }

        private function onKey(_arg_1:WindowKeyboardEvent):void
        {
            if (_inputText == null)
            {
                return;
            };

            events.dispatchEvent(new TextInputEvent(_inputText.text));
        }

    }
}
