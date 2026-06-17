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
    import com.sulake.habbo.utils.CommunicationUtils;
    import flash.geom.Rectangle;
    import onBoardingHcUi.Button;
    import onBoardingHc.OnBoardingHc;
    import onBoardingHc.IOnBoardingHcContext;

    public class OnBoardingHcStepLogin extends Sprite
    {

        private var _context:IOnBoardingHcContext;
        private var _titleField:TextField;
        private var _loginButton:ColouredButton;
        private var _cancelButton:ColouredButton;
        private var _registerButton:ColouredButton;
        private var _emailField:InputField;
        private var _loginAreaWidth:int = 640;
        private var _passwordField:InputField;
        private var _initialized:Boolean;

        public function OnBoardingHcStepLogin(context:IOnBoardingHcContext)
        {
            _context = context;
            addEventListener("addedToStage", onAddedToStage);
            init();
        }

        public function dispose():void
        {
            _loginButton.dispose();
            _cancelButton.dispose();
            _registerButton.dispose();
        }

        private function onAddedToStage(stageEvent:Event):void
        {
            var alignTimer:Timer = new Timer(20, 1);
            alignTimer.addEventListener("timerComplete", onAlignElements);
            alignTimer.start();
        }

        private function onAlignElements(alignEvent:TimerEvent):void
        {
            LoaderUI.lineUpVertically(_emailField, -20, _passwordField);
            LoaderUI.alignAnchors(_emailField, 0, "l", _passwordField);
            LoaderUI.alignAnchors(_emailField, 0, "r", _loginButton);
            LoaderUI.lineUpHorizontallyRevers(_loginButton, 20, _cancelButton);
            LoaderUI.lineUpVertically(_cancelButton, 20, _registerButton);
            LoaderUI.alignAnchors(_cancelButton, 0, "l", _registerButton);
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
            _emailField = new InputField(_context, _loginAreaWidth, "${connection.login.email}", CommunicationUtils.readSOLString("login"), "${connection.login.missing_credentials}", "");
            addChild(_emailField);
            _emailField.x = 0;
            _emailField.y = 100;

            _passwordField = new InputField(_context, _loginAreaWidth, "${connection.login.password}", CommunicationUtils.restorePassword(), "", "", true);
            addChild(_passwordField);
        }

        public function addButtons():void
        {
            _cancelButton = new ColouredButton("red", "${generic.cancel}", new Rectangle(0, 300, 0, 40), true, onCancel, 0xD8D8D8);
            addChild(_cancelButton);

            _loginButton = new ColouredButton("gfreen", "${connection.login.play}", new Rectangle(0, 300, 0, 40), true, onLogin, 0xD8D8D8);
            _loginButton.active = false;
            addChild(_loginButton);

            _registerButton = new ColouredButton("gfreen", "${connection.login.register}", new Rectangle(0, 350, 0, 40), true, onRegister, 0xD8D8D8);
            addChild(_registerButton);
        }

        private function onLogin(loginButton:Button):void
        {
            _context.initLogin(_emailField.text, _passwordField.text);
        }

        private function onCancel(cancelButton:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_ENVIRONMENT);
        }

        private function onRegister(registerButton:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_REGISTER);
        }

        public function ready():void
        {
            if (_loginButton != false)
                _loginButton.active = true;
        }

    }
}
