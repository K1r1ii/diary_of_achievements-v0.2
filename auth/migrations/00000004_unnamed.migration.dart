import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration4 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_User", "patronymic", (c) {c.isNullable = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    