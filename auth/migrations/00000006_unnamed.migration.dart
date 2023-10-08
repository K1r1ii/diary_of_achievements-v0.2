import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration6 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_User", SchemaColumn("refreshToken", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    