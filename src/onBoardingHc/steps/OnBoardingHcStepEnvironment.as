package onBoardingHc.steps
{
    import flash.display.Sprite;
    import com.sulake.core.runtime.IDisposable;
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import flash.text.TextField;
    import onBoardingHcUi.Button;
    import flash.utils.Timer;
    import flash.events.Event;
    import onBoardingHcUi.LoaderUI;
    import flash.events.TimerEvent;
    import onBoardingHcUi.ColouredButton;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import onBoardingHc.OnBoardingHc;

    public class OnBoardingHcStepEnvironment extends Sprite implements IDisposable
    {

        private static const flag_icon_de_png:Class = HabboEnvironmentView_flag_icon_de_png;
        private static const flag_icon_dev_png:Class = HabboEnvironmentView_flag_icon_dev_png;
        private static const flag_icon_en_png:Class = HabboEnvironmentView_flag_icon_en_png;
        private static const flag_icon_es_png:Class = HabboEnvironmentView_flag_icon_es_png;
        private static const flag_icon_fi_png:Class = HabboEnvironmentView_flag_icon_fi_png;
        private static const flag_icon_fr_png:Class = HabboEnvironmentView_flag_icon_fr_png;
        private static const flag_icon_it_png:Class = HabboEnvironmentView_flag_icon_it_png;
        private static const flag_icon_nl_png:Class = HabboEnvironmentView_flag_icon_nl_png;
        private static const flag_icon_pt_png:Class = HabboEnvironmentView_flag_icon_pt_png;
        private static const flag_icon_tr_png:Class = HabboEnvironmentView_flag_icon_tr_png;
        private static const flag_icon_selected_png:Class = HabboEnvironmentView_flag_icon_selected_png;

        private static const ITEMS_PER_ROW:int = 9;

        private var _flags:Vector.<Bitmap>;
        private var _context:OnBoardingHc;
        private var _titleField:TextField;
        private var _selectionOverlay:Bitmap;
        private var _environmentName:TextField;
        private var _selectedIndex:int = 0;
        private var _loginButton:Button;
        private var _loginWithCodeButton:Button;
        private var _environmentContainers:Array = [];
        private var _chosenIcon:Bitmap;
        private var _spacing:int = 10;
        private var _environments:Array;
        private var _initialized:Boolean;
        private var _selectionSprite:Sprite;

        public function OnBoardingHcStepEnvironment(_arg_1:OnBoardingHc)
        {
            _context = _arg_1;
            addEventListener("addedToStage", onAddedToStage);
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            var _local_2:Timer = new Timer(20, 1);
            _local_2.addEventListener("timerComplete", onAlignElements);
            _local_2.start();
        }

        private function onAlignElements(_arg_1:TimerEvent = null):void
        {
            LoaderUI.alignAnchors(this, 0, "c", _selectionOverlay);
            LoaderUI.alignAnchors(_selectionOverlay, 0, "r", _loginButton);
            LoaderUI.lineUpHorizontallyRevers(_loginButton, 20, _loginWithCodeButton);
        }

        public function dispose():void
        {
            if (disposed)
                return;

            _loginButton.dispose();
            _loginWithCodeButton.dispose();
            _flags = null;
            _context = null;
        }

        public function get disposed():Boolean
        {
            return (_context == null);
        }

        private function initFlags():void
        {
            _environments = _context.getProperty("live.environment.list").split("/");
            _flags = new Vector.<Bitmap>();
            _flags.push(Bitmap(new flag_icon_en_png()));
            _flags.push(Bitmap(new flag_icon_pt_png()));
            _flags.push(Bitmap(new flag_icon_de_png()));
            _flags.push(Bitmap(new flag_icon_es_png()));
            _flags.push(Bitmap(new flag_icon_fi_png()));
            _flags.push(Bitmap(new flag_icon_fr_png()));
            _flags.push(Bitmap(new flag_icon_it_png()));
            _flags.push(Bitmap(new flag_icon_nl_png()));
            _flags.push(Bitmap(new flag_icon_tr_png()));
            _flags.push(Bitmap(new flag_icon_dev_png()));
        }

        public function init():void
        {
            if (_initialized)
                return;

            _initialized = true;
            _flags = new Vector.<Bitmap>();

            if (_environments == null)
                initFlags();

            updateEnvironment();
            initView();
        }

        public function updateEnvironment():void
        {
            var _local_1:String = _context.getProperty("environment.id");
            var _local_2:int = _environments.indexOf(_local_1);
            _selectedIndex = (_local_2 == -1) ? 0 : _local_2;
            chooseEnvironment();
        }

        public function initView():void
        {
            var _local_7:int;
            var _local_8:Sprite;
            var _local_10:Bitmap;
            var _local_3:int;
            var _local_2:int;
            var _local_6:int;
            var _local_9:int;
            var _local_4:int;
            var _local_5:int;

            addTitleField();

            _selectionOverlay = LoaderUI.createBalloon(640, 100, 0, false, 995918, "none");
            _selectionOverlay.visible = false;
            addChild(_selectionOverlay);

            _selectionSprite = new Sprite();
            addChild(_selectionSprite);
            _chosenIcon = Bitmap(new flag_icon_selected_png());
            _selectionSprite.addChild(_chosenIcon);

            var _local_11:Number = 0.5;
            _selectionSprite.scaleY = _local_11;
            _selectionSprite.scaleX = _local_11;

            var _local_1:int = 100;
            _local_7 = 0;

            while (_local_7 < _flags.length)
            {
                _local_8 = new Sprite();
                _local_10 = (_flags[_local_7] as Bitmap);

                if (_local_10 != null)
                    _local_8.addChild(_local_10);

                addChild(_local_8);
                _environmentContainers.push(_local_8);
                _local_8.name = String(_local_7);
                _local_8.addEventListener("click", onEnvironmentClick);
                _local_11 = 0.5;
                _local_8.scaleY = _local_11;
                _local_8.scaleX = _local_11;
                _local_3 = 80;
                _local_2 = 5;
                _local_6 = (_local_7 % 9);
                _local_9 = int((_local_7 / 9));
                _local_4 = ((_local_6 * _local_3) + (_local_6 * _local_2));
                _local_5 = ((_local_9 * _local_3) + (_local_9 * _local_2));
                _local_8.x = _local_4;
                _local_8.y = (_local_1 + _local_5);
                _local_7++;
            };

            _environmentName = LoaderUI.createTextField("", 20, 0xFFFFFF, false, true, false, false);
            _environmentName.width = 260;
            _environmentName.y = 300;
            addChild(_environmentName);

            _loginButton = new ColouredButton("gfreen", "${connection.login.login}", new Rectangle(0, 300, 0, 40), true, onButtonSelect);
            addChild(_loginButton);

            _loginWithCodeButton = new ColouredButton("gfreen", "${connection.login.useTicket}", new Rectangle(0, 300, 0, 40), true, onButtonSelectToken);
            addChild(_loginWithCodeButton);

            chooseEnvironment();
        }

        private function addTitleField():void
        {
            if (!_titleField)
            {
                _titleField = LoaderUI.createTextField("${connection.login.environment.choose}", 40, 0xFFFFFF, false, true, false, false, "left");
                _titleField.x = 0;
                _titleField.y = 0;
                _titleField.width = 500;
                _titleField.multiline = false;
                _titleField.thickness = 50;
                addChild(_titleField);
            };
        }

        private function onEnvironmentClick(_arg_1:Event):void
        {
            _selectedIndex = _arg_1.currentTarget.name;
            chooseEnvironment();
            _context.updateEnvironment(_environments[_selectedIndex], true);
            onAlignElements();
        }

        private function chooseEnvironment():void
        {
            var _local_1:Sprite = _environmentContainers[_selectedIndex];

            if (_local_1 == null)
                return;

            _selectionSprite.x = ((_local_1.x - ((_selectionSprite.width - _local_1.width) / 2)) - 1);
            _selectionSprite.y = ((_local_1.y - ((_selectionSprite.height - _local_1.height) / 2)) - 1);
            _selectionSprite.visible = true;
            _loginButton.active = true;
            updateDescription();
        }

        private function onButtonSelect(_arg_1:DisplayObject):void
        {
            _context.updateEnvironment(_environments[_selectedIndex], false);
            _context.showScreen(OnBoardingHc.SCREEN_LOGIN);
        }

        private function onButtonSelectToken(_arg_1:DisplayObject):void
        {
            _context.updateEnvironment(_environments[_selectedIndex], false);
            _context.showScreen(OnBoardingHc.SCREEN_SSO_TOKEN);
        }

        private function updateDescription():void
        {
            var _local_1:String = _environments[_selectedIndex];
            _environmentName.text = _context.getProperty(("connection.info.name." + _local_1));
        }

        public function get environmentId():String
        {
            return (_environments[_selectedIndex]);
        }

        public function get environmentAvailable():Boolean
        {
            var _local_1:String = _context.getProperty("environment.id");
            return (_environments.indexOf(_local_1) > -1);
        }

    }
}
