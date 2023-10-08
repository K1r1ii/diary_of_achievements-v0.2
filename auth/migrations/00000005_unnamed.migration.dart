import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration5 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_Role", "description", (c) {c.isNullable = true;});
		database.deleteColumn("_User", "refreshToken");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    