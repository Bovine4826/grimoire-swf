package grimoire.game
{
   import grimoire.Root;
   
   public class Aura
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
       
      
      public function Aura()
      {
         super();
      }
      
      public static function isAuraActive(param1:String, param2:String) : String
      {
         var _loc4_:Object = null;
         var _loc3_:Object = param1 == "Self" ? game.world.myAvatar.dataLeaf.auras : game.world.myAvatar.target.dataLeaf.auras;
         var _loc5_:String = Root.falseString;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.nam.toLowerCase() == param2.toLowerCase())
            {
               _loc5_ = Root.trueString;
               break;
            }
         }
         return _loc5_;
      }
      
      public static function isAuraWithStrValActive(param1:String, param2:String, param3:String) : String
      {
         var _loc5_:Object = null;
         var _loc4_:Object = param1 == "Self" ? game.world.myAvatar.dataLeaf.auras : game.world.myAvatar.target.dataLeaf.auras;
         var _loc6_:String = Root.falseString;
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.nam.toLowerCase() == param2.toLowerCase() && (_loc5_.val == null || _loc5_.val == "undefined" || _loc5_.val == ""))
            {
               _loc6_ = Root.falseString;
               break;
            }
            if(_loc5_.nam.toLowerCase() == param2.toLowerCase() && _loc5_.val.toLowerCase() == param3.toLowerCase())
            {
               _loc6_ = Root.trueString;
               break;
            }
         }
         return _loc6_;
      }
      
      public static function auraComparison(param1:String, param2:String, param3:String, param4:int) : String
      {
         var _loc6_:Object = null;
         var _loc5_:Object = param1 == "Self" ? game.world.myAvatar.dataLeaf.auras : game.world.myAvatar.target.dataLeaf.auras;
         var _loc7_:String = Root.falseString;
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.nam.toLowerCase() == param3.toLowerCase())
            {
               if(_loc6_.val == null || _loc6_.val == "undefined" || _loc6_.val == "")
               {
                  _loc7_ = Root.falseString;
                  break;
               }
               if(param2 == "Greater" && _loc6_.val.toFixed(0) > param4.toFixed(0))
               {
                  _loc7_ = Root.trueString;
                  break;
               }
               if(param2 == "Less" && _loc6_.val.toFixed(0) < param4.toFixed(0))
               {
                  _loc7_ = Root.trueString;
                  break;
               }
               if(param2 == "Equal" && _loc6_.val.toFixed(0) == param4.toFixed(0))
               {
                  _loc7_ = Root.trueString;
                  break;
               }
            }
         }
         return _loc7_;
      }
   }
}
