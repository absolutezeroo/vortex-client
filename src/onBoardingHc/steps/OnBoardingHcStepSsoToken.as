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
        private var _registerButton:ColouredButton;
        private var _loginAreaWidth:int = 640;
        private var _tokenField:InputField;
        private var _initialized:Boolean;

        public function OnBoardingHcStepSsoToken(context:OnBoardingHc)
        {
            _context = context;
            addEventListener("addedToStage", onAddedToStage);
            init();
        }

        public function dispose():void
        {
            if (_tokenField)
                _tokenField.removeEventListener("change", onInputChange);

            if (_registerButton)
            {
                _registerButton.dispose();
            }
        }

        private function onAlignButtons():void
        {
            LoaderUI.alignAnchors(_tokenField, 0, "r", _playButton);
            LoaderUI.alignAnchors(_playButton, (-20 - _cancelButton.width), "l", _cancelButton);
            LoaderUI.lineUpVertically(_cancelButton, 20, _registerButton);
            LoaderUI.alignAnchors(_cancelButton, 0, "l", _registerButton);
        }

        private function onAddedToStage(stageEvent:Event):void
        {
            var alignTimer:Timer = new Timer(20, 1);
            alignTimer.addEventListener("timerComplete", onAlignElements);
            alignTimer.start();
        }

        private function onAlignElements(alignEvent:TimerEvent):void
        {
            onAlignButtons();
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

        private function onInputKeyboardEvent(keyboardEvent:KeyboardEvent):void
        {
            if (keyboardEvent.charCode == 13)
            {
                if ((_playButton) && (_playButton.active))
                    onLogin(null);
            };
        }

        private function onInputChange(inputEvent:Event):void
        {
            var tokenParts:Vector.<String> = new Vector.<String>();

            if (validateToken(tokenParts))
            {
                _context.updateEnvironment(tokenParts[0], true);
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

            _registerButton = new ColouredButton("gfreen", "${connection.login.register}", new Rectangle(0, 350, 0, 40), true, onRegister, 0xD8D8D8);
            addChild(_registerButton);

            onAlignButtons();
        }

        private function onRegister(registerButton:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_REGISTER);
        }

        private function onLogin(loginButton:Button):void
        {
            var tokenParts:Vector.<String> = new Vector.<String>();

            if (validateToken(tokenParts))
            {
                _context.initLoginWithSsoToken(tokenParts[0], tokenParts[1]);
            }
            else
            {
                _playButton.active = false;
            };
        }

        private function validateToken(tokenParts:Vector.<String>):Boolean
        {
            var tokenValue:String = _tokenField.text;

            if (!tokenValue || tokenValue.length == 0)
                return (false);

            var tokenSegments:Array = tokenValue.split(".");

            if (tokenSegments.length < 2)
                return (false);

            var environment:String = tokenSegments[0].replace("hh", "");
            environment = environment.replace("br", "pt");
            environment = environment.replace("us", "en");
            tokenParts.push(environment);
            tokenParts.push((tokenSegments as Array).slice(1).join("."));
            return (true);
        }

        private function onCancel(cancelButton:Button):void
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
