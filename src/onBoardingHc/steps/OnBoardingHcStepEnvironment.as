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

        public function OnBoardingHcStepEnvironment(context:OnBoardingHc)
        {
            _context = context;
            addEventListener("addedToStage", onAddedToStage);
        }

        private function onAddedToStage(stageEvent:Event):void
        {
            var alignTimer:Timer = new Timer(20, 1);
            alignTimer.addEventListener("timerComplete", onAlignElements);
            alignTimer.start();
        }

        private function onAlignElements(layoutEvent:TimerEvent = null):void
        {
            LoaderUI.alignAnchors(this, 0, "c", _selectionOverlay);
            LoaderUI.alignAnchors(_selectionOverlay, 0, "r", _loginButton);
            if ((_context) && (_context.isSsoEnabled))
            {
                _loginWithCodeButton.visible = true;
                LoaderUI.lineUpHorizontallyRevers(_loginButton, 20, _loginWithCodeButton);
            }
            else
            {
                if (_loginWithCodeButton)
                {
                    _loginWithCodeButton.visible = false;
                };
            };
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

            var environmentCode:String;
            var environmentFlag:Bitmap;

            for each (environmentCode in _environments)
            {
                if ((environmentCode == null) || (environmentCode.length == 0))
                {
                    continue;
                };

                environmentFlag = resolveEnvironmentFlag(environmentCode.toLowerCase());
                _flags.push(environmentFlag);
            }

            if (_flags.length == 0)
            {
                _flags.push(resolveEnvironmentFlag("en"));
                _environments = new Array("en");
            }
            else
            {
                if (_flags.length < _environments.length)
                {
                    while (_flags.length < _environments.length)
                    {
                        _flags.push(resolveEnvironmentFlag("dev"));
                    };
                }
                else
                {
                    if (_flags.length > _environments.length)
                    {
                        _flags.splice(_environments.length, (_flags.length - _environments.length));
                    };
                };
            };
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
            var currentEnvironment:String = _context.getProperty("environment.id");
            var environmentIndex:int = _environments.indexOf(currentEnvironment);
            _selectedIndex = (environmentIndex == -1) ? 0 : environmentIndex;
            chooseEnvironment();
        }

        public function initView():void
        {
            var flagIndex:int;
            var flagContainer:Sprite;
            var flagBitmap:Bitmap;
            var cellWidth:int;
            var cellMargin:int;
            var cellColumn:int;
            var cellRow:int;
            var iconX:int;
            var iconY:int;

            addTitleField();

            _selectionOverlay = LoaderUI.createBalloon(640, 100, 0, false, 995918, "none");
            _selectionOverlay.visible = false;
            addChild(_selectionOverlay);

            _selectionSprite = new Sprite();
            addChild(_selectionSprite);
            _chosenIcon = Bitmap(new flag_icon_selected_png());
            _selectionSprite.addChild(_chosenIcon);

            var overlayScale:Number = 0.5;
            _selectionSprite.scaleY = overlayScale;
            _selectionSprite.scaleX = overlayScale;

            var containerOffsetY:int = 100;
            flagIndex = 0;

            while (flagIndex < _flags.length)
            {
                flagContainer = new Sprite();
                flagBitmap = (_flags[flagIndex] as Bitmap);

                if (flagBitmap != null)
                    flagContainer.addChild(flagBitmap);

                addChild(flagContainer);
                _environmentContainers.push(flagContainer);
                flagContainer.name = String(flagIndex);
                flagContainer.addEventListener("click", onEnvironmentClick);
                overlayScale = 0.5;
                flagContainer.scaleY = overlayScale;
                flagContainer.scaleX = overlayScale;
                cellWidth = 80;
                cellMargin = 5;
                cellColumn = (flagIndex % 9);
                cellRow = int((flagIndex / 9));
                iconX = ((cellColumn * cellWidth) + (cellColumn * cellMargin));
                iconY = ((cellRow * cellWidth) + (cellRow * cellMargin));
                flagContainer.x = iconX;
                flagContainer.y = (containerOffsetY + iconY);
                flagIndex++;
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

        private function onEnvironmentClick(clickEvent:Event):void
        {
            _selectedIndex = clickEvent.currentTarget.name;
            chooseEnvironment();
            _context.updateEnvironment(_environments[_selectedIndex], true);
            onAlignElements();
        }

        private function chooseEnvironment():void
        {
            var selectedFlag:Sprite = _environmentContainers[_selectedIndex];

            if (selectedFlag == null)
                return;

            _selectionSprite.x = ((selectedFlag.x - ((_selectionSprite.width - selectedFlag.width) / 2)) - 1);
            _selectionSprite.y = ((selectedFlag.y - ((_selectionSprite.height - selectedFlag.height) / 2)) - 1);
            _selectionSprite.visible = true;
            _loginButton.active = true;
            updateDescription();
        }

        private function onButtonSelect(button:DisplayObject):void
        {
            _context.updateEnvironment(_environments[_selectedIndex], false);
            _context.showScreen(OnBoardingHc.SCREEN_LOGIN);
        }

        private function onButtonSelectToken(button:DisplayObject):void
        {
            if (!(_context && _context.isSsoEnabled))
            {
                return;
            };

            _context.updateEnvironment(_environments[_selectedIndex], false);
            _context.showScreen(OnBoardingHc.SCREEN_SSO_TOKEN);
        }

        private function resolveEnvironmentFlag(environmentCode:String):Bitmap
        {
            switch (environmentCode)
            {
                case "en":
                    return (Bitmap(new flag_icon_en_png()));
                case "pt":
                    return (Bitmap(new flag_icon_pt_png()));
                case "de":
                    return (Bitmap(new flag_icon_de_png()));
                case "es":
                    return (Bitmap(new flag_icon_es_png()));
                case "fi":
                    return (Bitmap(new flag_icon_fi_png()));
                case "fr":
                    return (Bitmap(new flag_icon_fr_png()));
                case "it":
                    return (Bitmap(new flag_icon_it_png()));
                case "nl":
                    return (Bitmap(new flag_icon_nl_png()));
                case "tr":
                    return (Bitmap(new flag_icon_tr_png()));
                case "s2":
                case "dev":
                    return (Bitmap(new flag_icon_dev_png()));
                default:
                    return (Bitmap(new flag_icon_dev_png()));
            };
        }

        private function updateDescription():void
        {
            var selectedEnvironment:String = _environments[_selectedIndex];
            _environmentName.text = _context.getProperty(("connection.info.name." + selectedEnvironment));
        }

        public function get environmentId():String
        {
            return (_environments[_selectedIndex]);
        }

        public function get environmentAvailable():Boolean
        {
            var currentEnvironment:String = _context.getProperty("environment.id");
            return (_environments.indexOf(currentEnvironment) > -1);
        }

    }
}
