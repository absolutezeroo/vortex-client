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

        public function OnBoardingHc(config:Dictionary)
        {
            createFakeContext(config);
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

        private function createConfiguration(context:IContext):HabboConfigurationManager
        {
            var manifestXml:XML = new XML("<manifest><library /></manifest>");
            var manifestBytes:ByteArray = (new HabboConfigurationCom.manifest() as ByteArray);
            var configurationXml:XML = new XML(manifestBytes.readUTFBytes(manifestBytes.length));
            manifestXml.library.appendChild(configurationXml.component.assets);

            var configurationLibrary:IAssetLibrary = new AssetLibrary("_assetsConfiguration@");
            configurationLibrary.loadFromResource(manifestXml, HabboConfigurationCom);
            return (new HabboConfigurationManager(context, 0, configurationLibrary));
        }

        private function createLocalization(context:IContext):HabboLocalizationManager
        {
            var manifestXml:XML = new XML("<manifest><library /></manifest>");
            var localizationBytes:ByteArray = (new HabboLocalizationCom.manifest() as ByteArray);
            var localizationXml:XML = new XML(localizationBytes.readUTFBytes(localizationBytes.length));
            manifestXml.library.appendChild(localizationXml.component.assets);

            var localizationLibrary:IAssetLibrary = new AssetLibrary("_assetsLocalization@");
            localizationLibrary.loadFromResource(manifestXml, HabboLocalizationCom);
            return (new HabboLocalizationManager(context, 0, localizationLibrary));
        }

        private function createCommunication(context:IContext):HabboCommunicationManager
        {
            var communicationBytes:ByteArray = (new HabboCommunicationCom.manifest() as ByteArray);
            var communicationXml:XML = new XML(communicationBytes.readUTFBytes(communicationBytes.length));
            var manifestXml:XML = new XML("<manifest><library /></manifest>");
            manifestXml.library.appendChild(communicationXml.component.assets);

            var communicationLibrary:IAssetLibrary = new AssetLibrary("_assetsTemp@", manifestXml);
            communicationLibrary.loadFromResource(manifestXml, HabboCommunicationCom);
            return (new HabboCommunicationManager(context, 0, communicationLibrary));
        }

        private function createFakeContext(config:Dictionary):void
        {
            _context = new FakeContext(config);

            var manifestXml:XML = new XML("<manifest><library /></manifest>");
            var tempLibrary:IAssetLibrary = new AssetLibrary("_assetsTemp@", manifestXml);
            (_context.assets as AssetLibraryCollection).addAssetLibrary(tempLibrary);
            _configuration = createConfiguration(_context);
            _localization = createLocalization(_context);
            _communication = createCommunication(_context);
            LocalizedSprite.localizationManager = _localization;
            LocalizedTextField.localizationManager = _localization;
            _localization.loadDefaultEmbedLocalizations(_configuration.getProperty("environment.id"));
            _loginProvider = new WebApiLoginProvider(this);
            _loginProvider.addEventListener("SSO_TOKEN_AVAILABLE", onSsoTokenAvailable);
        }

        private function onSsoTokenAvailable(ssoTokenEvent:SsoTokenAvailableEvent):void
        {
            _ssoToken = ssoTokenEvent.ssoToken;
            dispatchEvent(new Event(FLOW_FINISHED_EVENT));
        }

        public function initLoginWithSsoToken(environmentId:String, ssoToken:String):void
        {
            updateEnvironment(environmentId, false);
            _ssoToken = ssoToken;
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

            var logoBitmap:Bitmap = new habbo_logo_png();
            logoBitmap.x = 40;
            logoBitmap.y = 40;
            _logoArea.addChild(logoBitmap);

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

        private function onImageComplete(loaderEvent:ImageLoaderEvent):void
        {
            Logger.log(("Image complete: " + loaderEvent.url));
            loaderEvent.loader.visible = true;
            TweenUtils.alphaTweenVisible(loaderEvent.loader, 0, 1.2);
            layoutElements();
        }

        private function onAddedToStage(stageEvent:Event):void
        {
            removeEventListener("addedToStage", onAddedToStage);
            _lastFrameTime = getTimer();
            layoutElements();
        }

        private function onEnterFrame(frameEvent:Event):void
        {
            TweenUtils._SafeStr_265.advanceTime(((getTimer() - _lastFrameTime) / 1000));
            _lastFrameTime = getTimer();
        }

        private function onStageResize(stageEvent:Event):void
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

            var minMainAreaWidth:int = (_mainArea.width + 20);

            if (stage.stageWidth > minMainAreaWidth)
            {
                var centeredX:int = int(((stage.stageWidth - minMainAreaWidth) / 2));

                if (centeredX < 5)
                    centeredX = 5;

                _mainArea.x = centeredX;
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

        public function showErrorMessage(errorMessage:String):void
        {
            var messageField:TextField;
            var background:Bitmap;

            if (_errorBalloon == null)
            {
                messageField = LoaderUI.createTextField(errorMessage, 12, 0xFFFFFF, true);
                LoaderUI.addEtching(messageField, true);
                background = LoaderUI.createBalloon((messageField.width + 30), (messageField.height + 17), -1, true, 11411485, "down");
                _errorBalloon = new Sprite();
                _errorBalloon.addChild(background);
                _errorBalloon.addChild(messageField);
                messageField.x = 15;
                messageField.y = 14;
                _mainArea.addChild(_errorBalloon);
                _errorBalloon.x = 300;
                _errorBalloon.y = 300;
                _errorBalloon.filters = [new GlowFilter(0, 0.24, 6, 6)];
            };

            var hideTimer:Timer = new Timer(3000, 1);
            hideTimer.addEventListener("timerComplete", onHideError);
            hideTimer.start();
            _errorBalloon.visible = true;
        }

        private function onHideError(_:TimerEvent):void
        {
            if (_errorBalloon)
                _errorBalloon.visible = false;
        }

        public function editorFinished():void
        {
            dispatchEvent(new Event(FLOW_FINISHED_EVENT));
        }

        public function showScreen(screenId:int):void
        {
            hideSteps();

            switch (screenId)
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

        public function initLogin(email:String, password:String):void
        {
            _loginProvider.loginWithCredentials(email, password);
        }

        public function loginWithAvatar(avatar:AvatarData):void
        {
            _loginProvider.loginWithCredentialsWeb(avatar.uniqueId);
        }

        public function registerAccount(email:String, password:String):void
        {
            // Delegates to WebApiLoginProvider which calls /api/public/registration/new
            if (_loginProvider is WebApiLoginProvider)
            {
                (WebApiLoginProvider(_loginProvider)).register(email, password);
            };
        }

        public function createAvatar(name:String, figure:String, gender:String):void
        {
            // name, figure, gender
            if (_loginProvider is WebApiLoginProvider)
            {
                (WebApiLoginProvider(_loginProvider)).createAvatar(name, figure, gender);
            };
        }

        public function checkName(name:String):void
        {
            if (_loginProvider is WebApiLoginProvider)
            {
                (WebApiLoginProvider(_loginProvider)).checkName(name);
            };
        }

        public function showLoginScreen():void
        {
        }

        public function showRegistrationError(error:Object):void
        {
            showError(error);
        }

        public function showInvalidLoginError(error:Object):void
        {
            showError(error);
        }

        public function nameCheckResponse(response:Object, isValid:Boolean):void
        {
            _stepAvatarCreate.onNameCheckResult(response, isValid);
        }

        public function showAccountError(error:Object):void
        {
            showError(error);
        }

        public function showLoadingScreen():void
        {
        }

        public function saveLooksError(error:Object):void
        {
            showError(error);
        }

        public function showTOS():void
        {
            showErrorMessage("Need to show TOS");
        }

        public function environmentReady():void
        {
            _stepLogin.ready();
        }

        public function populateCharacterList(avatars:Vector.<AvatarData>):void
        {
            showScreen(SCREEN_AVATAR_SELECT);
            _stepAvatarSelect.populateAvatars(avatars);
        }

        public function showSelectAvatar(avatar:Object):void
        {
            showScreen(SCREEN_AVATAR_CREATE);
        }

        public function showPromoHabbos(promoXml:XML):void
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

        private function showError(error:Object):void
        {
            var localizationKey:String;
            var errorList:Array = error ? error.errors : null;
            var resolvedError:String = ((errorList) && (errorList.length > 0)) ? errorList[0] : "";

            if ((resolvedError == "") && (!(error == null)))
            {
                if (error.error != null)
                    resolvedError = error.error;
                else if (error.message != null)
                    resolvedError = error.message;
            };

            switch (resolvedError)
            {
                case "invalid-captcha":
                    showCaptchaError();
                    break;
                case "login.user_banned":
                    localizationKey = "connection.login.error.banned.desc";
                    break;
                case "login.blocked":
                    localizationKey = "connection.login.error.blocked.desc";
                    break;
                case "unauthorized-staff-login":
                    localizationKey = "connection.login.error.unauthorized.staff";
                    break;
                case "pocket.auth.login_failed":
                    localizationKey = "connection.login.error.-3.desc";
                    break;
                case "pocket.auth.no_avatars":
                    localizationKey = "connection.login.missing_avatars";
                    break;
                case "pocket.auth.valid_email_required":
                    localizationKey = "connection.login.missing_credentials";
                    break;
                case "pocket.auth.password_required":
                    localizationKey = "connection.login.missing_credentials";
                    break;
                case "ioError":
                    localizationKey = "connection.login.error.-400.desc";
                    break;
                default:
                    localizationKey = "generic.error";
            };

            if ((localizationKey) && (localizationKey.length > 0))
                showErrorMessage(_localization.getLocalization(localizationKey));
        }

        public function getProperty(propertyKey:String, parameters:Dictionary = null):String
        {
            var propertyValue:String = ((_configuration) ? _configuration.getProperty(propertyKey, parameters) : "");

            if ((!(propertyValue)) || (propertyValue.length == 0))
                Logger.log(("[OnBoardingHc] Add property: " + propertyKey));

            return (propertyValue);
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

        private function onClose(closeButton:Button):void
        {
            removeChild(_closeButton);
            showScreen(SCREEN_LOGIN);
        }

        public function updateEnvironment(environmentId:String, shouldLoadLocalization:Boolean):void
        {
            if (shouldLoadLocalization)
            {
                _localization.loadDefaultEmbedLocalizations(environmentId);
                return;
            };

            CommunicationUtils.writeSOLProperty("environment", environmentId);
            _configuration.updateEnvironmentId(environmentId);

            if (_stepEnvironment)
                _stepEnvironment.updateEnvironment();

            _localization.loadDefaultEmbedLocalizations(_configuration.getProperty("environment.id"));
            Logger.log(("[OnBoardingHc] updated environment: " + environmentId));
            _communication.updateHostParameters();
            _localization.requestLocalizationInit();
        }

    }
}
