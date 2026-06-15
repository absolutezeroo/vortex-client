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

    public class OnBoardingHcStepAvatarCreate extends Sprite
    {

        private var _context:IOnBoardingHcContext;
        private var _titleField:TextField;
        private var _createButton:ColouredButton;
        private var _cancelButton:ColouredButton;
        private var _maleButton:ColouredButton;
        private var _femaleButton:ColouredButton;
        private var _fieldWidth:int = 640;
        private var _nameField:InputField;
        private var _statusField:TextField;
        private var _initialized:Boolean;
        private var _nameChecked:Boolean;
        private var _nameValid:Boolean;
        private var _selectedGender:String = "M";

        public function OnBoardingHcStepAvatarCreate(_arg_1:IOnBoardingHcContext)
        {
            _context = _arg_1;
            addEventListener("addedToStage", onAddedToStage);
        }

        public function dispose():void
        {
            if (_createButton)
                _createButton.dispose();

            if (_cancelButton)
                _cancelButton.dispose();

            if (_maleButton)
                _maleButton.dispose();

            if (_femaleButton)
                _femaleButton.dispose();
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            var _local_2:Timer = new Timer(20, 1);
            _local_2.addEventListener("timerComplete", onAlignElements);
            _local_2.start();
        }

        private function onAlignElements(_arg_1:TimerEvent):void
        {
            LoaderUI.alignAnchors(_nameField, 0, "r", _createButton);
            LoaderUI.lineUpHorizontallyRevers(_createButton, 20, _cancelButton);
            LoaderUI.lineUpVertically(_nameField, 20, _maleButton);
            LoaderUI.lineUpHorizontallyRevers(_maleButton, 10, _femaleButton);
            LoaderUI.lineUpVertically(_maleButton, 10, _statusField);
        }

        public function init():void
        {
            if (_initialized)
                return;

            _initialized = true;
            _nameChecked = false;
            _nameValid = false;
            addTitleField();
            addInputFields();
            addGenderButtons();
            addButtons();
        }

        private function addTitleField():void
        {
            if (!_titleField)
            {
                _titleField = LoaderUI.createTextField("${connection.login.create_avatar.title}", 40, 0xFFFFFF, false, true, false, false, "left");
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
            _nameField = new InputField(_context, _fieldWidth, "${connection.login.create_avatar.name}", "", "${connection.login.create_avatar.name_hint}", "");
            addChild(_nameField);
            _nameField.x = 0;
            _nameField.y = 100;
            _nameField.addEventListener("change", onNameChange);

            _statusField = LoaderUI.createTextField("", 14, 0xFFCC00, false);
            _statusField.x = 0;
            _statusField.y = 260;
            _statusField.width = _fieldWidth;
            addChild(_statusField);
        }

        private function addGenderButtons():void
        {
            _maleButton = new ColouredButton("gfreen", "${connection.login.create_avatar.male}", new Rectangle(0, 220, 0, 36), true, onSelectMale, 0xD8D8D8);
            addChild(_maleButton);

            _femaleButton = new ColouredButton("red", "${connection.login.create_avatar.female}", new Rectangle(0, 220, 0, 36), true, onSelectFemale, 0xD8D8D8);
            addChild(_femaleButton);
        }

        public function addButtons():void
        {
            _cancelButton = new ColouredButton("red", "${generic.cancel}", new Rectangle(0, 310, 0, 40), true, onCancel, 0xD8D8D8);
            addChild(_cancelButton);

            _createButton = new ColouredButton("gfreen", "${connection.login.create_avatar.submit}", new Rectangle(0, 310, 0, 40), true, onCreate, 0xD8D8D8);
            _createButton.active = false;
            addChild(_createButton);
        }

        private function onSelectMale(_arg_1:Button):void
        {
            _selectedGender = "M";
            _maleButton.active = false;
            _femaleButton.active = true;
        }

        private function onSelectFemale(_arg_1:Button):void
        {
            _selectedGender = "F";
            _femaleButton.active = false;
            _maleButton.active = true;
        }

        private function onNameChange(_arg_1:Event):void
        {
            _nameChecked = false;
            _nameValid = false;
            _createButton.active = false;

            var _local_2:String = _nameField.text;

            if (_local_2 && _local_2.length >= 3)
            {
                _statusField.text = "${connection.login.create_avatar.checking}";
                _context.checkName(_local_2);
            }
            else
            {
                _statusField.text = "";
            };
        }

        public function onNameCheckResult(_arg_1:Object, _arg_2:Boolean):void
        {
            _nameChecked = true;

            if (_arg_2)
            {
                // name/check response — true means it IS a check (not a select)
                var _local_3:Boolean = (_arg_1 && _arg_1.valid == true);
                _nameValid = _local_3;

                if (_local_3)
                {
                    _statusField.text = "${connection.login.create_avatar.name_available}";
                    _createButton.active = true;
                }
                else
                {
                    _statusField.text = "${connection.login.create_avatar.name_taken}";
                    _createButton.active = false;
                };
            };
        }

        private function onCreate(_arg_1:Button):void
        {
            if (!_nameValid)
                return;

            var _local_2:String = _nameField.text;

            if (!_local_2 || _local_2.length < 3)
                return;

            // figure is empty — server uses the configured default figure
            _context.createAvatar(_local_2, "", _selectedGender);
        }

        private function onCancel(_arg_1:Button):void
        {
            _context.showScreen(OnBoardingHc.SCREEN_AVATAR_SELECT);
        }

    }
}
