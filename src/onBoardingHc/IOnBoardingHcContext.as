package onBoardingHc
{
    import onBoardingHcUi.IUIContext;
    import com.sulake.habbo.communication.login.AvatarData;

    public interface IOnBoardingHcContext extends IUIContext
    {
        function initLogin(_arg_1:String, _arg_2:String):void;
        function initLoginWithSsoToken(_arg_1:String, _arg_2:String):void;
        function loginWithAvatar(_arg_1:AvatarData):void;
        function showScreen(_arg_1:int):void;
        function registerAccount(_arg_1:String, _arg_2:String):void;
        function createAvatar(_arg_1:String, _arg_2:String, _arg_3:String):void;
        function checkName(_arg_1:String):void;
    }
}
