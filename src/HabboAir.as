package {
    import flash.display.MovieClip;
    import login.LoginFlow;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    import flash.external.ExternalInterface;
    import com.sulake.core.runtime.ICoreErrorLogger;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.system.Capabilities;
    import flash.system.System;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.net.sendToURL;
    import com.sulake.habbo.utils.CommunicationUtils;
    import flash.events.Event;
    import flash.events.UncaughtErrorEvent;
    import com.sulake.air._SafeStr_12;
    import com.sulake.core.utils.MouseWheelEnabler;
    import flash.events.HTTPStatusEvent;
    import flash.utils.setTimeout;
    import flash.events.IOErrorEvent;
    import flash.display.DisplayObject;
    import flash.utils.getDefinitionByName;
    import ClientEnum;

    [SWF(backgroundColor="0x000000")]
    public class HabboAir extends MovieClip {

        public static const CORE_RATIO:Number = 0.6;
        private static const ESTIMATED_MAIN_SWF_SIZE:int = 7000000;
        public static const ERROR_VARIABLE_IS_FATAL:String = "is_fatal";
        public static const ERROR_VARIABLE_CLIENT_CRASH_TIME:String = "crash_time";
        public static const ERROR_VARIABLE_CONTEXT:String = "error_ctx";
        public static const ERROR_VARIABLE_FLASH_VERSION:String = "flash_version";
        public static const ERROR_VARIABLE_AVERAGE_UPDATE_INTERVAL:String = "avg_update";
        public static const ERROR_VARIABLE_DEBUG:String = "debug";
        public static const ERROR_VARIABLE_DESCRIPTION:String = "error_desc";
        public static const ERROR_VARIABLE_CATEGORY:String = "error_cat";
        public static const ERROR_VARIABLE_DATA:String = "error_data";
        private static const RECEPTION_LOG_STEP_FUNCTION:String = "NewUserReception.logStep";
        private static const STEP_NUX_ENTERED:String = "NUX_ENTERED";
        private static const STEP_RECEPTION_EXITED:String = "RECEPTION_EXITED";
        private static const STEP_NUX_EXITED:String = "NUX_EXITED";
        private static const STEP_CLIENT_LOADED:String = "CLIENT_LOADED";
        public static const ERROR_CATEGORY_FINALIZE_PRELOADING:int = 9;
        public static const ERROR_CATEGORY_DOWNLOAD_FONT:int = 11;
        public static const ERROR_UNCAUGHT_ERROR:int = 40;
        private static const ARGUMENT_ENVIRONMENT:String = "server";
        private static const ARGUMENT_SSO_TOKEN:String = "ticket";

        protected static var PROCESSLOG_ENABLED:Boolean = false;
        private static var _crashReportUrl:String = "http://vortex-assets.local/api/log/crash";
        private static var _fatalCrashSent:Boolean = false;

        private var _bytesProgressDirty:Boolean;
        private var _cachedBytesTotal:uint;
        private var _cachedBytesLoaded:uint;
        private var _httpStatus:int;
        private var _disposed:Boolean = false;
        private var _preloadComplete:Boolean;
        private var _loadingScreen:IHabboLoadingScreen;
        private var _startTime:int;
        private var _loginFlow:LoginFlow = null;
        private var _stageReady:Boolean;
        private var _argumentsParsed:Boolean;
        private var _loginScreenEnabled:Boolean = true;
        private var _gzipEnvironmentLogged:Boolean = false;
        private var _parameters:Dictionary;

        public function HabboAir() {
            super();

            var domainValidator:DomainValidator = new DomainValidator();

            if (!domainValidator.validate(this)) {
                return;
            }
            ;

            _startTime = getTimer();

            stop();

            _parameters = new Dictionary();

            if (stage) {
                onAddedToStage();
            }

            else {
                this.addEventListener("addedToStage", onAddedToStage);
            }
            ;

            parseArguments([]);
        }

        public static function trackLoginStep(step:String, extra:String = null):void {
            Logger.log(("* HabboMain Login Step: " + step));

            if (PROCESSLOG_ENABLED) {
                try {
                    if (ExternalInterface.available) {
                        if (extra != null) {
                            ExternalInterface.call("FlashExternalInterface.logLoginStep", step, extra);
                        }

                        else {
                            ExternalInterface.call("FlashExternalInterface.logLoginStep", step);
                        }
                    }

                    else {
                        Logger.log("ExternalInterface is not available, tracking is disabled");
                    }
                }

                catch (e:Error) {
                }
            }
        }

        public static function reportCrash(description:String, category:int, isFatal:Boolean, error:Error = null, errorLogger:ICoreErrorLogger = null):void {
            var stackTrace:String = ((error == null) ? "" : error.getStackTrace());

            reportCrashStack(description, category, isFatal, stackTrace, errorLogger);
        }

        public static function reportCrashStack(description:String, category:int, isFatal:Boolean, stackTrace:String, errorLogger:ICoreErrorLogger = null):void {
            var i:int;
            var request:URLRequest = new URLRequest(HabboAir._crashReportUrl);
            var vars:URLVariables = new URLVariables();

            vars["crash_time"] = new Date().getTime().toString();
            vars["is_fatal"] = isFatal.toString();
            vars["error_ctx"] = "";
            vars["flash_version"] = Capabilities.version;
            vars["avg_update"] = 0;
            vars["error_desc"] = description;
            vars["error_cat"] = String(category);

            if (stackTrace != "") {
                vars["error_data"] = stackTrace;
            }

            vars["debug"] = (("Memory usage: " + Math.round((System.totalMemory / 0x100000))) + " MB");

            var paramNames:Array = ErrorReportStorage.getParameterNames();
            var paramCount:int = paramNames.length;
            i = 0;

            while (i < paramCount) {
                vars[paramNames[i]] = ErrorReportStorage.getParameter(paramNames[i]);
                i++;
            }

            vars["debug"] = ErrorReportStorage.getDebugData();

            if (isFatal) {
                if (!_fatalCrashSent) {
                    _fatalCrashSent = true;
                }
            }

            request.data = vars;
            request.method = "POST";

            try {
                (sendToURL(request));
            }

            catch (e:Error) {
                Logger.log(("Error while sending error report: " + e.message));
            }
        }

        private function onBrowserInvoke(event:*):void {
            Logger.log(("Received Browser Invoke: " + event.arguments));
        }

        private function onInvoke(event:*):void {
        }

        private function parseArguments(args:Array):void {
            var pairCount:int;
            var i:int;
            var key:String;
            var value:String;

            _parameters = new Dictionary();

            if (((args) && (args.length))) {
                if ((args.length % 2) != 0) {
                }

                pairCount = int((args.length / 2));
                i = 0;

                while (i < pairCount) {
                    if (((i * 2) + 1) < args.length) {
                        key = args[(i * 2)];
                        value = args[((i * 2) + 1)];
                        key = key.replace("-", "");

                        if (key == "server") {
                            value = value.replace("hh", "");
                            value = value.replace("br", "pt");
                            value = value.replace("us", "en");
                            _parameters["environment.id"] = value;

                            CommunicationUtils.writeSOLProperty("environment", value);
                        }

                        if (key == "ticket") {
                            _parameters["sso.token"] = value;
                        }
                    }

                    i++;
                }
            }

            if (!_parameters["environment.id"]) {
                _parameters["environment.id"] = "en";

                CommunicationUtils.writeSOLProperty("environment", "en");
            }

            _argumentsParsed = true;
            tryInit();
        }

        private function onAddedToStage(event:Event = null):void {
            removeEventListener("addedToStage", onAddedToStage);
            _stageReady = true;
            tryInit();
        }

        private function tryInit():void {
            if (((!(_argumentsParsed)) || (!(_stageReady)))) {
                return;
            }

            var clientFatalErrorUrl:String = _parameters["client.fatal.error.url"];

            if (clientFatalErrorUrl != null) {
                _crashReportUrl = clientFatalErrorUrl;
            }

            else {
                var urlPrefix:String = _parameters["url.prefix"];

                if (urlPrefix != null) {
                    _crashReportUrl = (urlPrefix + "/flash_client_error");
                }
            }

            PROCESSLOG_ENABLED = (_parameters["processlog.enabled"] == "1");

            trackLoginStep(ClientEnum.CLIENT_START);
            stage.scaleMode = "noScale";
            stage.quality = "low";
            stage.align = "TL";
            root.loaderInfo.addEventListener("progress", onPreLoadingProgress);
            root.loaderInfo.addEventListener("httpStatus", onPreLoadingStatus);
            root.loaderInfo.addEventListener("complete", onPreLoadingCompleted);
            root.loaderInfo.addEventListener("ioError", onPreLoadingFailed);
            root.loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError", function(uncaughtError:UncaughtErrorEvent):void {
                reportCrash((((((("Uncaught client error, eventType: " + uncaughtError.type) + " errorID: ") + uncaughtError.errorID) + " runtime: ") + ((getTimer() - _startTime) / 1000)) + "s"), 40, true, uncaughtError.error);
            });

            if (_SafeStr_12.isSupported()) {
                CommunicationUtils.encryptedLocalStorage = new _SafeStr_12();
            }

            createNewUserLobbyOrLoadingScreen();
            checkPreLoadingStatus();

            MouseWheelEnabler.init(stage);
        }

        private function onLoginFLowFinished(event:Event):void {
            _parameters["sso.token"] = _loginFlow.ssoToken;
            _parameters["environment.id"] = CommunicationUtils.readSOLString("environment");
            _loginFlow.removeEventListener("LOGIN_FLOW_FINISHED_EVENT", onLoginFLowFinished);
            _loginFlow.dispose();
            _loginFlow = null;
            _loadingScreen = null;
            createLoadingScreen();
            checkPreLoadingStatus();
        }

        private function onPreLoadingStatus(event:HTTPStatusEvent):void {
            _httpStatus = event.status;
        }

        private function onPreLoadingProgress(event:Event):void {
            checkPreLoadingStatus();
            updateLoadingBarProgress();
            _bytesProgressDirty = true;
        }

        private function onPreLoadingCompleted(event:Event):void {
            try {
                _preloadComplete = true;
                checkPreLoadingStatus();
            }

            catch (error:Error) {
                trackLoginStep(ClientEnum.CLIENT_SWF_ERROR);
                reportCrash((((("Failed to finalize main swf preloading: " + error.message) + " runtime: ") + ((getTimer() - _startTime) / 1000)) + "s"), 9, true, error);
            }
        }

        private function onPreLoadingFailed(ioError:IOErrorEvent):void {
            var event:IOErrorEvent = ioError;

            setTimeout(function():void {
                trackLoginStep(ClientEnum.CLIENT_SWF_ERROR);
                reportCrash((((((((((((("IO error in main swf preloading: " + event.text) + " / URL: ") + root.loaderInfo.loaderURL) + " / HTTP status: ") + _httpStatus) + " / Loaded: ") + root.loaderInfo.bytesLoaded) + " of ") + root.loaderInfo.bytesTotal) + " bytes. Runtime: ") + ((getTimer() - _startTime) / 1000)) + "s"), 9, true, null);
            }, 5000); // not popped
        }

        private function checkPreLoadingStatus():void {
            if (_loginFlow != null) {
                return;
            }

            if (((_preloadComplete) && (progress >= 1))) {
                finalizePreloading();

                return;
            }
        }

        private function calculateProgress():void {
            _cachedBytesLoaded = root.loaderInfo.bytesLoaded;

            if (root.loaderInfo.bytesTotal == 0) {
                if (!_gzipEnvironmentLogged) {
                    _cachedBytesTotal = 7000000;
                    _gzipEnvironmentLogged = true;

                    trackLoginStep(ClientEnum.CLIENT_GZIP_ENVIRONMENT);
                }
            }

            if (root.loaderInfo.bytesTotal != 0) {
                _cachedBytesTotal = root.loaderInfo.bytesTotal;
            }

            if (((_cachedBytesTotal < _cachedBytesLoaded) || (_preloadComplete))) {
                _cachedBytesTotal = _cachedBytesLoaded;
            }

            _bytesProgressDirty = false;

            if (((!(_preloadComplete)) && (_cachedBytesLoaded == _cachedBytesTotal))) {
                _bytesProgressDirty = true;
                _cachedBytesLoaded = (_cachedBytesLoaded * 0.99);
            }
        }

        private function clone(source:Dictionary):Dictionary {
            var copy:Dictionary = new Dictionary();

            for (var key:Object in source) {
                if ((source[key] is Dictionary)) {
                    copy[key] = clone(source[key]);
                }

                else {
                    copy[key] = source[key];
                }
            }

            return (copy);
        }

        private function createNewUserLobbyOrLoadingScreen():void {
            if (((!(ssoTokenAvailable)) && (_loginScreenEnabled))) {
                _loginFlow = new LoginFlow(clone(_parameters));
                _loginFlow.addEventListener("LOGIN_FLOW_FINISHED_EVENT", onLoginFLowFinished);
                stage.addChild(_loginFlow);
                _loginFlow.init();
                updateLoadingBarProgress();

                return;
            }

            createLoadingScreen();
        }

        public function createLoadingScreen():void {
            _loadingScreen = new HabboLoadingScreen(stage.stageWidth, stage.stageHeight, clone(_parameters));
            updateLoadingBarProgress();
            stage.addChild(DisplayObject(_loadingScreen));
        }

        private function updateLoadingBarProgress():void {
            var ratio:Number;
            var loadProgress:Number;

            if (_loadingScreen != null) {
                loadProgress = progress;

                if (loadProgress == 0) {
                    ratio = ((bytesLoaded / 7000000) * 0.6);
                }

                else {
                    ratio = (loadProgress * 0.6);
                }

                _loadingScreen.updateLoadingBar(ratio);
            }
        }

        private function finalizePreloading():void {
            var mainClass:Class;
            var mainInstance:DisplayObject;
            trackLoginStep(ClientEnum.CLIENT_SWF_LOADED);
            root.loaderInfo.removeEventListener("progress", onPreLoadingProgress);
            root.loaderInfo.removeEventListener("httpStatus", onPreLoadingStatus);
            root.loaderInfo.removeEventListener("complete", onPreLoadingCompleted);
            root.loaderInfo.removeEventListener("ioError", onPreLoadingFailed);
            nextFrame();
            mainClass = Class(getDefinitionByName("HabboAirMain"));

            if (mainClass) {
                mainInstance = (new mainClass(_loadingScreen, _parameters) as HabboAirMain);

                if (mainInstance) {
                    mainInstance.addEventListener("removed", onMainRemoved, false, 0, true);
                    addChild(mainInstance);
                }
            }
        }

        private function onMainRemoved(event:Event):void {
            dispose();
        }

        private function dispose():void {
            removeEventListener("addedToStage", onAddedToStage);

            if (!_disposed) {
                _disposed = true;

                if (_loadingScreen != null) {
                    _loadingScreen = null;
                }

                if (parent) {
                    parent.removeChild(this);
                }
            }
        }

        public function get progress():Number {
            return ((this.bytesTotal != 0) ? (bytesLoaded / bytesTotal) : ((_preloadComplete) ? 1 : 0));
        }

        public function get bytesLoaded():uint {
            if (_bytesProgressDirty) {
                calculateProgress();
            }

            return (_cachedBytesLoaded);
        }

        public function get bytesTotal():uint {
            if (_bytesProgressDirty) {
                calculateProgress();
            }

            return (_cachedBytesTotal);
        }

        private function get ssoTokenAvailable():Boolean {
            var token:String = _parameters["sso.token"];

            return ((!( token == null)) && (token.length > 0));
        }

    }
}
