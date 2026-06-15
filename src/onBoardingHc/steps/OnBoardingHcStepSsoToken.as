package onBoardingHc.steps
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import onBoardingHcUi.ColouredButton;
    import onBoardingHcUi.InputField;
    import flash.utils.Timer;
    import flash.events.Event;
    import onBoardingHcUi.LoaderUI;
    import flash.events.TimerEvent;
    import flash.events.KeyboardEvent;
    import __AS3__.vec.Vector;
    import flash.geom.Rectangle;
    import onBoardingHcUi.Button;
    import onBoardingHc.OnBoardingHc;

    public class OnBoardingHcStepSsoToken extends Sprite
    {

        private var _context:OnBoardingHc;
        private var _titleField:TextField;
        private var _playButton:ColouredButton;
        private var _cancelButton:ColouredButton;
        private var _loginAreaWidth:int = 640;
        private var _tokenField:InputField;
        private var _initialized:Boolean;

        public function OnBoardingHcStepSsoToken(_arg_1:OnBoardingHc)
        {
            _context = _arg_1;
            addEventListener("addedToStage", onAddedToStage);
            init();
        }

        public function dispose():void
        {
            if (_tokenField)
                _tokenField.removeEventListener("change", onInputChange);
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            var _local_2:Timer = new Timer(20, 1);
            _local_2.addEventListener("timerComplete", onAlignElements);
            _local_2.start();
        }

        private function onAlignElements(_arg_1:TimerEvent):void
        {
            LoaderUI.alignAnchors(_tokenField, 0, "r", _playButton);
            LoaderUI.alignAnchors(_playButton, (-20 - _cancelButton.width), "l", _cancelButton);
        }

        public function init():void
        {
            if (_initialized)
                return;

            _initialized = true;
            addTitleField();
            addInputFields();
            addButtons();
        }

        private function addTitleField():void
        {
            if (!_titleField)
            {
                _titleField = LoaderUI.createTextField("${connection.login.title}", 40, 0xFFFFFF, false, true, false, false, "left");
                _titleField.x = 0;
                _titleField.y = 0;
                _titleField.width = 500;
                _titleField.multiline = false;
                _titleField.thickness = 50;
                addChild(_titleField);
            };
        }

        private function addInputFields():void
        {
            _tokenField = new InputField(_context, _loginAreaWidth, "${connection.login.code.prompt}", "", "${connection.login.useTicket}", "", true);
            addChild(_tokenField);
            _tokenField.addEventListener("change", onInputChange);
            _tokenField.addEventListener("keyDown", onInputKeyboardEvent);
            _tokenField.x = 0;
            _tokenField.y = 100;
        }

        private function onInputKeyboardEvent(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.charCode == 13)
            {
                if ((_playButton) && (_playButton.active))
                    onLogin(null);
            };
        }

        private function onInputChange(_arg_1:Event):void
        {
            var _local_2:Vector.<String> = new Vector.<String>();

            if (validateToken(_local_2))
            {
                _context.updateEnvironment(_local_2[0], true);
                _playButton.active = true;
            }
            else
            {
                _playButton.active = false;
            };
        }

        public function addButtons():void
        {
            _cancelButton = new ColouredButton("red", "${generic.cancel}", new Rectangle(0, 300, 0, 40), true, onCancel, 0xD8D8D8);
            addChild(_cancelButton);

            _playButton = new ColouredButton("gfreen", "${connection.login.play}", new Rectangle(0, 300, 0, 40), true, onLogin, 0xD8D8D8);
            _playButton.active = false;
            addChild(_playButton);
        }

        private function onLogin(_arg_1:Button):void
        {
            var _local_2:Vector.<String> = new Vector.<String>();

            if (validateToken(_local_2))
            {
                _context.initLoginWithSsoToken(_local_2[0], _local_2[1]);
            }
            else
            {
                _playButton.active = false;
            };
        }

        private function validateToken(_arg_1:Vector.<String>):Boolean
        {
            var _local_4:String = _tokenField.text;

            if (!_local_4 || _local_4.length == 0)
                return (false);

            var _local_3:Array = _local_4.split(".");

            if (_local_3.length < 2)
                return (false);

            var _local_2:String = _local_3[0].replace("hh", "");
            _local_2 = _local_2.replace("br", "pt");
            _local_2 = _local_2.replace("us", "en");
            _arg_1.push(_local_2);
            _arg_1.push((_local_3 as Array).slice(1).join("."));
            return (true);
        }

        private function onCancel(_arg_1:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_ENVIRONMENT);
        }

        public function ready():void
        {
            if (_playButton != false)
                _playButton.active = true;
        }

    }
}
