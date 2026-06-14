package com.sulake.habbo.phonenumber
{
    import com.sulake.core.window.components.IFrameWindow;
    import flash.utils.Timer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import flash.utils.getTimer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ILabelWindow;
    import flash.events.TimerEvent;

    public class VerificationCodeInputView 
    {

        private static const INPUT_MAX_CHARS:int = 10;

        private var _component:HabboPhoneNumber;
        private var _window:IFrameWindow;
        private var _inputTextNeedsClearing:Boolean = true;
        private var _waitTimer:Timer;

        public function VerificationCodeInputView(_arg_1:HabboPhoneNumber)
        {
            _component = _arg_1;
            createWindow();
        }

        public function dispose():void
        {
            if (_window)
            {
                _window.dispose();
                _window = null;
            };

            if (_waitTimer)
            {
                _waitTimer.reset();
                _waitTimer = null;
            };

            _component = null;
        }

        public function handleSubmitFailure(_arg_1:int):void
        {
            _component.windowManager.alert("${generic.alert.title}", (("${phone.number.verify.error." + _arg_1) + "}"), 0, null);
            ITextFieldWindow(_window.findChildByName("verification_code_input")).textColor = 0xFF0000;
            _window.findChildByName("verification_code_input").enable();
            _inputTextNeedsClearing = true;
        }

        private function createWindow():void
        {
            if (_window)
            {
                return;
            };

            _window = IFrameWindow(_component.windowManager.buildFromXML(XML(_component.assets.getAssetByName("phonenumber_verify_xml").content)));
            _window.center();

            if (_window.findChildByName("wait_link"))
            {
                _window.findChildByName("wait_link").procedure = onInputButtons;
            };

            _window.findChildByName("ok_button").procedure = onInputButtons;

            if (_window.findChildByName("header_button_close"))
            {
                _window.findChildByName("header_button_close").visible = false;
            };

            _window.findChildByName("verification_code_input").procedure = onInputButtons;
            _window.findChildByName("did_not_receive_code_link").procedure = onInputButtons;
            _window.findChildByName("ok_button").disable();
            _window.findChildByName("verification_code_input").enable();

            if ((_component.retryEnableTime - getTimer()) <= 0)
            {
                showRetry();
            }

            else
            {
                showWaitForRetry();
            };

            ITextFieldWindow(_window.findChildByName("verification_code_input")).maxChars = 10;
            _inputTextNeedsClearing = true;
        }

        private function onInputButtons(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            switch (_arg_2.name)
            {
                case "header_button_close":
                case "wait_link":
                    _component.setVerifyViewMinimized(true);
                    return;
                case "did_not_receive_code_link":
                    _component.requestPhoneNumberCollectionReset();
                    return;
                case "ok_button":
                    _component.sendTryVerificationCode(_window.findChildByName("verification_code_input").caption);
                    _window.findChildByName("ok_button").disable();
                    _window.findChildByName("verification_code_input").disable();
                    return;
                case "verification_code_input":

                    if (_inputTextNeedsClearing)
                    {
                        _window.findChildByName("verification_code_input").caption = "";
                        _inputTextNeedsClearing = false;
                    };

                    _window.findChildByName("ok_button").enable();
                    ITextFieldWindow(_window.findChildByName("verification_code_input")).textColor = 0;
                    return;
            };
        }

        public function showRetry():void
        {
            _window.findChildByName("did_not_receive_code_link").visible = true;
            _window.findChildByName("retry_wait_label").visible = false;
        }

        public function showWaitForRetry(_arg_1:int=0):void
        {
            _window.findChildByName("did_not_receive_code_link").visible = false;
            _window.findChildByName("retry_wait_label").visible = true;
            onWaitTimer();
            _waitTimer = new Timer(1000);
            _waitTimer.addEventListener("timer", onWaitTimer);
            _waitTimer.start();
        }

        private function onWaitTimer(_arg_1:TimerEvent=null):void
        {
            var _local_3:String = _component.localizationManager.getLocalization("phone.number.verify.wait.remaining", "");
            var _local_2:int = int(Math.max(0, ((_component.retryEnableTime - getTimer()) / 1000)));
            _local_3 = _local_3.replace("{0}", _local_2);
            (_window.findChildByName("retry_wait_label") as ILabelWindow).text = _local_3;

            if (_local_2 == 0)
            {
                if (_waitTimer)
                {
                    _waitTimer.stop();
                };

                _waitTimer = null;
                showRetry();
            };
        }

    }
}
