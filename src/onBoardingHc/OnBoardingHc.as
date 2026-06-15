package onBoardingHc
{
    import flash.display.Sprite;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.login.ILoginViewer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.habbo.configuration.HabboConfigurationManager;
    import com.sulake.habbo.communication.HabboCommunicationManager;
    import com.sulake.habbo.localization.HabboLocalizationManager;
    import com.sulake.habbo.communication.login.ILoginProvider;
    import onBoardingHcUi.ColouredButton;
    import flash.display.Loader;
    import flash.utils.Dictionary;
    import onBoardingHcUi.LocalizedSprite;
    import onBoardingHcUi.LocalizedTextField;
    import flash.utils.ByteArray;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.AssetLibraryCollection;
    import com.sulake.habbo.communication.login.WebApiLoginProvider;
    import flash.events.Event;
    import com.sulake.habbo.communication.login.SsoTokenAvailableEvent;
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    import com.sulake.habbo.utils.animation.TweenUtils;
    import flash.utils.getTimer;
    import flash.text.TextField;
    import onBoardingHcUi.LoaderUI;
    import flash.filters.GlowFilter;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.login.AvatarData;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.communication.login.ICaptchaView;
    import onBoardingHcUi.Button;
    import com.sulake.habbo.utils.CommunicationUtils;
    import onBoardingHc.steps.OnBoardingHcStepEnvironment;
    import onBoardingHc.steps.OnBoardingHcStepLogin;
    import onBoardingHc.steps.OnBoardingHcStepAvatarSelect;
    import onBoardingHc.steps.OnBoardingHcStepSsoToken;
    import onBoardingHc.steps.OnBoardingHcStepRegister;
    import onBoardingHc.steps.OnBoardingHcStepAvatarCreate;

    public class OnBoardingHc extends Sprite implements IOnBoardingHcContext, IDisposable, ILoginViewer
    {

        public static const FLOW_FINISHED_EVENT:String = "ONBOARDING_HC_FINISHED";

        public static const SCREEN_ENVIRONMENT:int = 1;
        public static const SCREEN_LOGIN:int = 2;
        public static const SCREEN_AVATAR_SELECT:int = 3;
        public static const SCREEN_SSO_TOKEN:int = 4;
        public static const SCREEN_REGISTER:int = 5;
        public static const SCREEN_AVATAR_CREATE:int = 6;

        public static var ubuntu_regular:Class = HabboLoginFlow_Habboubuntu_regular_ttf;
        public static var ubuntu_bold:Class = HabboLoginFlow_Habboubuntu_bold_ttf;
        public static var ubuntu_italic:Class = HabboLoginFlow_Habboubuntu_italic_ttf;
        public static var ubuntu_bold_italic:Class = HabboLoginFlow_Habboubuntu_bold_italic_ttf;
        private static const habbo_logo_png:Class = HabboLoginFlow_habbo_logo_png;

        private var _background:Background;
        private var _stepContainer:Sprite;
        private var _stepEnvironment:OnBoardingHcStepEnvironment;
        private var _stepLogin:OnBoardingHcStepLogin;
        private var _stepSsoToken:OnBoardingHcStepSsoToken;
        private var _stepAvatarSelect:OnBoardingHcStepAvatarSelect;
        private var _stepRegister:OnBoardingHcStepRegister;
        private var _stepAvatarCreate:OnBoardingHcStepAvatarCreate;
        private var _disposed:Boolean;
        private var _context:IContext;
        private var _errorBalloon:Sprite;
        private var _logoArea:Sprite;
        private var _mainArea:Sprite;
        private var _configuration:HabboConfigurationManager;
        private var _communication:HabboCommunicationManager;
        private var _localization:HabboLocalizationManager;
        private var _loginProvider:ILoginProvider;
        private var _ssoToken:String;
        private var _closeButton:ColouredButton;
        private var _bgLeft:Loader;
        private var _bgRight:Loader;
        private var _lastFrameTime:int;

        public function OnBoardingHc(_arg_1:Dictionary)
        {
            createFakeContext(_arg_1);
        }

        public function get ssoToken():String
        {
            return (_ssoToken);
        }

        public function dispose():void
        {
            removeEventListener("enterFrame", onEnterFrame);

            if (_disposed)
                return;

            if (_context)
            {
                _context.dispose();
                _context = null;
            };

            if (_background)
            {
                removeChild(_background);
                _background.dispose();
                _background = null;
            };

            if (_logoArea != null)
            {
                removeChild(_logoArea);
                _logoArea = null;
            };

            hideSteps();
            _stepEnvironment.dispose();
            _stepLogin.dispose();
            _stepAvatarSelect.dispose();
            _stepSsoToken.dispose();
            _loginProvider = null;
            stage.removeChild(this);
            _disposed = true;
            LocalizedSprite.localizationManager = null;
            LocalizedTextField.localizationManager = null;
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        private function createConfiguration(_arg_1:IContext):HabboConfigurationManager
        {
            var _local_5:XML = new XML("<manifest><library /></manifest>");
            var _local_2:ByteArray = (new HabboConfigurationCom.manifest() as ByteArray);
            var _local_3:XML = new XML(_local_2.readUTFBytes(_local_2.length));
            _local_5.library.appendChild(_local_3.component.assets);

            var _local_4:IAssetLibrary = new AssetLibrary("_assetsConfiguration@");
            _local_4.loadFromResource(_local_5, HabboConfigurationCom);
            return (new HabboConfigurationManager(_arg_1, 0, _local_4));
        }

        private function createLocalization(_arg_1:IContext):HabboLocalizationManager
        {
            var _local_5:XML = new XML("<manifest><library /></manifest>");
            var _local_2:ByteArray = (new HabboLocalizationCom.manifest() as ByteArray);
            var _local_3:XML = new XML(_local_2.readUTFBytes(_local_2.length));
            _local_5.library.appendChild(_local_3.component.assets);

            var _local_4:IAssetLibrary = new AssetLibrary("_assetsLocalization@");
            _local_4.loadFromResource(_local_5, HabboLocalizationCom);
            return (new HabboLocalizationManager(_arg_1, 0, _local_4));
        }

        private function createCommunication(_arg_1:IContext):HabboCommunicationManager
        {
            var _local_3:ByteArray = (new HabboCommunicationCom.manifest() as ByteArray);
            var _local_4:XML = new XML(_local_3.readUTFBytes(_local_3.length));
            var _local_2:XML = new XML("<manifest><library /></manifest>");
            _local_2.library.appendChild(_local_4.component.assets);

            var _local_5:IAssetLibrary = new AssetLibrary("_assetsTemp@", _local_2);
            _local_5.loadFromResource(_local_2, HabboCommunicationCom);
            return (new HabboCommunicationManager(_arg_1, 0, _local_5));
        }

        private function createFakeContext(_arg_1:Dictionary):void
        {
            _context = new FakeContext(_arg_1);

            var _local_3:XML = new XML("<manifest><library /></manifest>");
            var _local_2:IAssetLibrary = new AssetLibrary("_assetsTemp@", _local_3);
            (_context.assets as AssetLibraryCollection).addAssetLibrary(_local_2);
            _configuration = createConfiguration(_context);
            _localization = createLocalization(_context);
            _communication = createCommunication(_context);
            LocalizedSprite.localizationManager = _localization;
            LocalizedTextField.localizationManager = _localization;
            _localization.loadDefaultEmbedLocalizations(_configuration.getProperty("environment.id"));
            _loginProvider = new WebApiLoginProvider(this);
            _loginProvider.addEventListener("SSO_TOKEN_AVAILABLE", onSsoTokenAvailable);
        }

        private function onSsoTokenAvailable(_arg_1:SsoTokenAvailableEvent):void
        {
            _ssoToken = _arg_1.ssoToken;
            dispatchEvent(new Event(FLOW_FINISHED_EVENT));
        }

        public function initLoginWithSsoToken(_arg_1:String, _arg_2:String):void
        {
            updateEnvironment(_arg_1, false);
            _ssoToken = _arg_2;
            dispatchEvent(new Event(FLOW_FINISHED_EVENT));
        }

        public function init():void
        {
            stage.addEventListener("resize", onStageResize);
            _background = new Background();
            addChild(_background);

            _bgLeft = new Loader();
            _bgLeft.visible = false;
            _bgLeft.alpha = 0;
            addChild(_bgLeft);

            _bgRight = new Loader();
            _bgRight.visible = false;
            _bgRight.alpha = 0;
            addChild(_bgRight);

            _logoArea = new Sprite();
            addChild(_logoArea);

            var _local_1:Bitmap = new habbo_logo_png();
            _local_1.x = 40;
            _local_1.y = 40;
            _logoArea.addChild(_local_1);

            _mainArea = new Sprite();
            addChild(_mainArea);
            _mainArea.y = 50;
            _mainArea.x = 5;

            _stepContainer = new Sprite();
            _stepContainer.x = 0;
            _stepContainer.y = 50;
            _stepContainer.visible = true;
            _mainArea.addChild(_stepContainer);

            _stepEnvironment = new OnBoardingHcStepEnvironment(this);
            _stepLogin = new OnBoardingHcStepLogin(this);
            _stepAvatarSelect = new OnBoardingHcStepAvatarSelect(this);
            _stepSsoToken = new OnBoardingHcStepSsoToken(this);
            _stepRegister = new OnBoardingHcStepRegister(this);
            _stepAvatarCreate = new OnBoardingHcStepAvatarCreate(this);

            _closeButton = new ColouredButton("red", "X", new Rectangle(0, 0, 0, 40), true, onClose, 0xD8D8D8);

            _stepEnvironment.init();
            loadBackgroundImages();
            if (isSsoTokenEnabled())
            {
                showScreen(SCREEN_SSO_TOKEN);
            }
            else
            {
                showScreen(SCREEN_LOGIN);
            };
            layoutElements();

            addEventListener("addedToStage", onAddedToStage);
            addEventListener("enterFrame", onEnterFrame);
        }

        private function loadBackgroundImages():void
        {
            ImageLoader.CreateLoader(_bgRight, getProperty("landing.view.background_right.uri"), onImageComplete);
            ImageLoader.CreateLoader(_bgLeft, getProperty("landing.view.background_left.uri"), onImageComplete);
        }

        private function onImageComplete(_arg_1:ImageLoaderEvent):void
        {
            Logger.log(("Image complete: " + _arg_1.url));
            _arg_1.loader.visible = true;
            TweenUtils.alphaTweenVisible(_arg_1.loader, 0, 1.2);
            layoutElements();
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            removeEventListener("addedToStage", onAddedToStage);
            _lastFrameTime = getTimer();
            layoutElements();
        }

        private function onEnterFrame(_arg_1:Event):void
        {
            TweenUtils._SafeStr_265.advanceTime(((getTimer() - _lastFrameTime) / 1000));
            _lastFrameTime = getTimer();
        }

        private function onStageResize(_arg_1:Event):void
        {
            if (disposed)
                return;

            layoutElements();
        }

        private function layoutElements():void
        {
            if (disposed || _disposed)
                return;

            if (_background != null)
                _background.resize();

            var _local_1:int = (_mainArea.width + 20);

            if (stage.stageWidth > _local_1)
            {
                var _local_2:int = int(((stage.stageWidth - _local_1) / 2));

                if (_local_2 < 5)
                    _local_2 = 5;

                _mainArea.x = _local_2;
            }
            else
            {
                _mainArea.x = 5;
            };

            _mainArea.y = 50;
            _closeButton.y = 30;
            _closeButton.x = ((stage.stageWidth - _closeButton.width) - 30);
            _bgRight.x = Math.max(400, ((stage.stageWidth - _bgRight.width) + 50));
            _bgRight.y = ((stage.stageHeight - _bgRight.height) + 50);
            _bgLeft.x = -50;
            _bgLeft.y = ((stage.stageHeight - _bgLeft.height) + 50);
        }

        public function showErrorMessage(_arg_1:String):void
        {
            var _local_4:TextField;
            var _local_3:Bitmap;

            if (_errorBalloon == null)
            {
                _local_4 = LoaderUI.createTextField(_arg_1, 12, 0xFFFFFF, true);
                LoaderUI.addEtching(_local_4, true);
                _local_3 = LoaderUI.createBalloon((_local_4.width + 30), (_local_4.height + 17), -1, true, 11411485, "down");
                _errorBalloon = new Sprite();
                _errorBalloon.addChild(_local_3);
                _errorBalloon.addChild(_local_4);
                _local_4.x = 15;
                _local_4.y = 14;
                _mainArea.addChild(_errorBalloon);
                _errorBalloon.x = 300;
                _errorBalloon.y = 300;
                _errorBalloon.filters = [new GlowFilter(0, 0.24, 6, 6)];
            };

            var _local_2:Timer = new Timer(3000, 1);
            _local_2.addEventListener("timerComplete", onHideError);
            _local_2.start();
            _errorBalloon.visible = true;
        }

        private function onHideError(_arg_1:TimerEvent):void
        {
            if (_errorBalloon)
                _errorBalloon.visible = false;
        }

        public function editorFinished():void
        {
            dispatchEvent(new Event(FLOW_FINISHED_EVENT));
        }

        public function showScreen(_arg_1:int):void
        {
            hideSteps();

            switch (_arg_1)
            {
                case SCREEN_ENVIRONMENT:
                    _stepContainer.addChild(_stepEnvironment);
                    _stepEnvironment.init();
                    break;
                case SCREEN_LOGIN:
                    _stepContainer.addChild(_stepLogin);
                    _stepLogin.init();
                    _loginProvider.init(_communication);
                    break;
                case SCREEN_SSO_TOKEN:
                    _stepContainer.addChild(_stepSsoToken);
                    _stepSsoToken.init();
                    break;
                case SCREEN_AVATAR_SELECT:
                    _stepContainer.addChild(_stepAvatarSelect);
                    _stepAvatarSelect.init();
                    _stepAvatarSelect.baseUrl = getProperty("web.api");
                    layoutElements();
                    break;
                case SCREEN_REGISTER:
                    _stepContainer.addChild(_stepRegister);
                    _stepRegister.init();
                    break;
                case SCREEN_AVATAR_CREATE:
                    _stepContainer.addChild(_stepAvatarCreate);
                    _stepAvatarCreate.init();
                    break;
                default:
                    break;
            };

            layoutElements();
        }

        public function get debugText():TextField
        {
            return (null);
        }

        private function hideSteps():void
        {
            while (_stepContainer.numChildren > 0)
            {
                _stepContainer.removeChildAt(0);
            };
        }

        public function initLogin(_arg_1:String, _arg_2:String):void
        {
            _loginProvider.loginWithCredentials(_arg_1, _arg_2);
        }

        public function loginWithAvatar(_arg_1:AvatarData):void
        {
            _loginProvider.loginWithCredentialsWeb(_arg_1.uniqueId);
        }

        public function registerAccount(_arg_1:String, _arg_2:String):void
        {
            // Delegates to WebApiLoginProvider which calls /api/public/registration/new
            if (_loginProvider is WebApiLoginProvider)
            {
                (WebApiLoginProvider(_loginProvider)).register(_arg_1, _arg_2);
            };
        }

        public function createAvatar(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            // name, figure, gender
            if (_loginProvider is WebApiLoginProvider)
            {
                (WebApiLoginProvider(_loginProvider)).createAvatar(_arg_1, _arg_2, _arg_3);
            };
        }

        public function checkName(_arg_1:String):void
        {
            if (_loginProvider is WebApiLoginProvider)
            {
                (WebApiLoginProvider(_loginProvider)).checkName(_arg_1);
            };
        }

        public function showLoginScreen():void
        {
        }

        public function showRegistrationError(_arg_1:Object):void
        {
            showError(_arg_1);
        }

        public function showInvalidLoginError(_arg_1:Object):void
        {
            showError(_arg_1);
        }

        public function nameCheckResponse(_arg_1:Object, _arg_2:Boolean):void
        {
            _stepAvatarCreate.onNameCheckResult(_arg_1, _arg_2);
        }

        public function showAccountError(_arg_1:Object):void
        {
            showError(_arg_1);
        }

        public function showLoadingScreen():void
        {
        }

        public function saveLooksError(_arg_1:Object):void
        {
            showError(_arg_1);
        }

        public function showTOS():void
        {
            showErrorMessage("Need to show TOS");
        }

        public function environmentReady():void
        {
            _stepLogin.ready();
        }

        public function populateCharacterList(_arg_1:Vector.<AvatarData>):void
        {
            showScreen(SCREEN_AVATAR_SELECT);
            _stepAvatarSelect.populateAvatars(_arg_1);
        }

        public function showSelectAvatar(_arg_1:Object):void
        {
            showScreen(SCREEN_AVATAR_CREATE);
        }

        public function showPromoHabbos(_arg_1:XML):void
        {
        }

        public function showSelectRoom():void
        {
        }

        public function showCaptchaError():void
        {
            showScreen(SCREEN_LOGIN);
            showErrorMessage("Error with captcha");
        }

        private function showError(_arg_1:Object):void
        {
            var _local_3:String;
            var _local_4:Array = _arg_1 ? _arg_1.errors : null;
            var _local_2:String = ((_local_4) && (_local_4.length > 0)) ? _local_4[0] : "";

            if ((_local_2 == "") && (!(_arg_1 == null)))
            {
                if (_arg_1.error != null)
                    _local_2 = _arg_1.error;
                else if (_arg_1.message != null)
                    _local_2 = _arg_1.message;
            };

            switch (_local_2)
            {
                case "invalid-captcha":
                    showCaptchaError();
                    break;
                case "login.user_banned":
                    _local_3 = "connection.login.error.banned.desc";
                    break;
                case "login.blocked":
                    _local_3 = "connection.login.error.blocked.desc";
                    break;
                case "unauthorized-staff-login":
                    _local_3 = "connection.login.error.unauthorized.staff";
                    break;
                case "pocket.auth.login_failed":
                    _local_3 = "connection.login.error.-3.desc";
                    break;
                case "pocket.auth.no_avatars":
                    _local_3 = "connection.login.missing_avatars";
                    break;
                case "pocket.auth.valid_email_required":
                    _local_3 = "connection.login.missing_credentials";
                    break;
                case "pocket.auth.password_required":
                    _local_3 = "connection.login.missing_credentials";
                    break;
                case "ioError":
                    _local_3 = "connection.login.error.-400.desc";
                    break;
                default:
                    _local_3 = "generic.error";
            };

            if ((_local_3) && (_local_3.length > 0))
                showErrorMessage(_localization.getLocalization(_local_3));
        }

        public function getProperty(_arg_1:String, _arg_2:Dictionary = null):String
        {
            var _local_3:String = ((_configuration) ? _configuration.getProperty(_arg_1, _arg_2) : "");

            if ((!(_local_3)) || (_local_3.length == 0))
                Logger.log(("[OnBoardingHc] Add property: " + _arg_1));

            return (_local_3);
        }

        public function get isSsoEnabled():Boolean
        {
            return (isSsoTokenEnabled());
        }

        public function createCaptchaView():ICaptchaView
        {
            addChild(_closeButton);
            layoutElements();
            return (null);
        }

        private function isSsoTokenEnabled():Boolean
        {
            if (!_configuration)
            {
                return (false);
            };

            if (_configuration.propertyExists("use.sso"))
            {
                return (_configuration.getBoolean("use.sso"));
            };

            return (_configuration.getProperty("connection.info.login") == null);
        }

        public function captchaReady():void
        {
            removeChild(_closeButton);
            showScreen(SCREEN_LOGIN);
        }

        private function onClose(_arg_1:Button):void
        {
            removeChild(_closeButton);
            showScreen(SCREEN_LOGIN);
        }

        public function updateEnvironment(_arg_1:String, _arg_2:Boolean):void
        {
            if (_arg_2)
            {
                _localization.loadDefaultEmbedLocalizations(_arg_1);
                return;
            };

            CommunicationUtils.writeSOLProperty("environment", _arg_1);
            _configuration.updateEnvironmentId(_arg_1);

            if (_stepEnvironment)
                _stepEnvironment.updateEnvironment();

            _localization.loadDefaultEmbedLocalizations(_configuration.getProperty("environment.id"));
            Logger.log(("[OnBoardingHc] updated environment: " + _arg_1));
            _communication.updateHostParameters();
            _localization.requestLocalizationInit();
        }

    }
}
