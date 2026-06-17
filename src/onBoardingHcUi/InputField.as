package onBoardingHcUi
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class InputField extends Sprite
    {

        private var _style:int = 2;
        private var _disposed:Boolean;
        private var _context:IUIContext;
        private var _frame:Sprite;
        private var _promptField:TextField;
        private var _field:TextField;
        private var _submitButton:Button;
        private var _skipButton:Button;
        private var _background:Bitmap;
        private var _inputClickedAlready:Boolean;
        private var _inputDefaultString:String;
        private var _dialogWidth:int;
        private var _isPassword:Boolean;
        private var _caption:String;
        private var _subCaption:String;
        private var _maxWidth:Number;
        private var _prompt:String;

        public function InputField(uiContext:IUIContext, width:int, promptText:String, defaultText:String, title:String, subTitle:String, isPassword:Boolean = false)
        {
            _context = uiContext;
            _dialogWidth = width;
            _prompt = promptText;
            _inputDefaultString = ((defaultText == null) ? "" : defaultText);
            _caption = title;
            _subCaption = subTitle;
            _isPassword = isPassword;
            init();
        }

        public function dispose():void
        {
            if (_disposed)
            {
                return;
            };

            if (_frame)
            {
                removeChild(_frame);
            };

            _field = null;
            _promptField = null;
            _submitButton = null;
            _skipButton = null;
            _background = null;
            _frame = null;
            _context = null;
            _disposed = true;
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        private function init():void
        {
            _frame = LoaderUI.createFrame(_caption, _subCaption, new Rectangle(0, 0, _dialogWidth, 1), _style);
            addChild(_frame);

            var contentX:int = 0;
            var inputContainer:Sprite = new Sprite();
            _background = NineSplitSprite.INPUT_FIELD_HITCH.render(_dialogWidth, 31);
            inputContainer.addChild(_background);
            _frame.addChild(inputContainer);
            inputContainer.x = contentX;
            _maxWidth = (inputContainer.width - 30);
            _promptField = LoaderUI.createTextField(_prompt, 18, 0x666666, true, false, false, false);
            _promptField.alpha = 0.8;
            _promptField.x = (inputContainer.x + 16);
            _promptField.y = (inputContainer.y + int(((inputContainer.height - _promptField.height) / 2)));
            _promptField.width = _maxWidth;
            _promptField.visible = ((_inputDefaultString == null) || (_inputDefaultString.length == 0));
            _frame.addChild(_promptField);
            _field = LoaderUI.createTextField(_inputDefaultString, 18, 0x666666, true, false, true, false);
            _field.displayAsPassword = _isPassword;
            _frame.addChild(_field);
            _field.x = (inputContainer.x + 16);
            _field.y = (inputContainer.y + int(((inputContainer.height - _field.height) / 2)));
            _field.width = _maxWidth;
            _field.addEventListener("click", onInputClicked);
            _field.addEventListener("change", onInputChange);

            if (((!(_inputDefaultString)) || (_inputDefaultString.length == 0)))
            {
                _field.autoSize = "none";
                _field.width = _maxWidth;
            };

            inputContainer.addEventListener("click", onInputBackgroundClicked);

            var yOffset:int = -50;
            _frame.y = -(int((yOffset / 2)));
        }

        private function onInputChange(inputEvent:Event):void
        {
            _promptField.visible = (_field.text.length == 0);

            if (_field.width > _maxWidth)
            {
                _field.autoSize = "none";
                _field.width = _maxWidth;
            };

            if (inputEvent != null)
            {
                dispatchEvent(inputEvent.clone());
            };
        }

        private function onInputBackgroundClicked(_:MouseEvent):void
        {
            _context.stage.focus = _field;
            onInputClicked(null);
        }

        private function onInputClicked(_:Event):void
        {
            if (_inputClickedAlready)
            {
                return;
            };

            _promptField.visible = false;
            _inputClickedAlready = true;
            _field.textColor = ((_style == 2) ? 0x666666 : 0);
            _field.removeEventListener("click", onInputClicked);
            onInputChange(null);
        }

        public function get text():String
        {
            return (_field.text);
        }

    }
}
