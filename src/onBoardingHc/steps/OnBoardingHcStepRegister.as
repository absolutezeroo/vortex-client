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
    import flash.geom.Rectangle;
    import onBoardingHcUi.Button;
    import onBoardingHc.OnBoardingHc;
    import onBoardingHc.IOnBoardingHcContext;

    public class OnBoardingHcStepRegister extends Sprite
    {

        private var _context:IOnBoardingHcContext;
        private var _titleField:TextField;
        private var _registerButton:ColouredButton;
        private var _cancelButton:ColouredButton;
        private var _fieldWidth:int = 640;
        private var _emailField:InputField;
        private var _passwordField:InputField;
        private var _confirmField:InputField;
        private var _initialized:Boolean;

        public function OnBoardingHcStepRegister(_arg_1:IOnBoardingHcContext)
        {
            _context = _arg_1;
            addEventListener("addedToStage", onAddedToStage);
        }

        public function dispose():void
        {
            if (_registerButton)
                _registerButton.dispose();

            if (_cancelButton)
                _cancelButton.dispose();
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            var _local_2:Timer = new Timer(20, 1);
            _local_2.addEventListener("timerComplete", onAlignElements);
            _local_2.start();
        }

        private function onAlignElements(_arg_1:TimerEvent):void
        {
            LoaderUI.lineUpVertically(_emailField, -20, _passwordField);
            LoaderUI.lineUpVertically(_passwordField, -20, _confirmField);
            LoaderUI.alignAnchors(_emailField, 0, "l", _passwordField);
            LoaderUI.alignAnchors(_emailField, 0, "l", _confirmField);
            LoaderUI.alignAnchors(_emailField, 0, "r", _registerButton);
            LoaderUI.lineUpHorizontallyRevers(_registerButton, 20, _cancelButton);
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
                _titleField = LoaderUI.createTextField("${connection.login.register.title}", 40, 0xFFFFFF, false, true, false, false, "left");
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
            _emailField = new InputField(_context, _fieldWidth, "${connection.login.email}", "", "${connection.login.missing_credentials}", "");
            addChild(_emailField);
            _emailField.x = 0;
            _emailField.y = 100;

            _passwordField = new InputField(_context, _fieldWidth, "${connection.login.password}", "", "", "", true);
            addChild(_passwordField);

            _confirmField = new InputField(_context, _fieldWidth, "${connection.login.register.confirm_password}", "", "", "", true);
            addChild(_confirmField);
        }

        public function addButtons():void
        {
            _cancelButton = new ColouredButton("red", "${generic.cancel}", new Rectangle(0, 350, 0, 40), true, onCancel, 0xD8D8D8);
            addChild(_cancelButton);

            _registerButton = new ColouredButton("gfreen", "${connection.login.register.submit}", new Rectangle(0, 350, 0, 40), true, onRegister, 0xD8D8D8);
            addChild(_registerButton);
        }

        private function onRegister(_arg_1:Button):void
        {
            var _local_2:String = _emailField.text;
            var _local_3:String = _passwordField.text;
            var _local_4:String = _confirmField.text;

            if (!_local_2 || _local_2.length == 0)
            {
                return;
            };

            if (!_local_3 || _local_3.length < 6)
            {
                return;
            };

            if (_local_3 != _local_4)
            {
                return;
            };

            _context.registerAccount(_local_2, _local_3);
        }

        private function onCancel(_arg_1:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_LOGIN);
        }

    }
}
