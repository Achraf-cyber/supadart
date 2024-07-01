import 'package:supabase/supabase.dart';
import 'package:supadart_test/generated_classes.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../utils.dart';

// Array Test for Timestamptz
Future<void> performTimestamptzArrayTest(SupabaseClient supabase) async {
  // List of DateTimes with assumed timezones
  List<DateTime> insertTimestamptzes = [
    DateTime(2021, 10, 10, 10, 10, 10).toUtc(),
    DateTime.now(),
  ];

  List<DateTime> updatedTimestamptzes = [
    DateTime.now().toUtc(),
    DateTime(2021, 12, 12, 12, 12, 12).toUtc(),
  ];

  // Tests for Timestamptz array
  test('Testing Timestamptz Array Create', () async {
    await cleanup(supabase, supabase.datetime_types);
    var createResult =
        await createTimestamptzArray(supabase, insertTimestamptzes);
    expect(createResult, null);
  });

  test('Testing Timestamptz Array Update', () async {
    var updateResult = await updateTimestamptzArray(
        supabase, insertTimestamptzes, updatedTimestamptzes);
    expect(updateResult, null);
  });

  test('Testing Timestamptz Array Read', () async {
    var readResult = await readTimestamptzArray(supabase);
    assert(readResult is List<DatetimeTypes>);
    expect(readResult!.length, 1);

    // Assuming order is preserved during update
    for (int i = 0; i < insertTimestamptzes.length; i++) {
      var storedTimestamp = readResult[0].col_timestamptz_array![i];
      expect(storedTimestamp, isA<DateTime>());

      // Convert both timestamps to UTC for comparison
      var updatedTimestamptzUtc = updatedTimestamptzes[i].toUtc();
      var storedTimestampUtc = storedTimestamp.toUtc();

      // Compare the UTC timestamps
      expect(storedTimestampUtc.year, updatedTimestamptzUtc.year);
      expect(storedTimestampUtc.month, updatedTimestamptzUtc.month);
      expect(storedTimestampUtc.day, updatedTimestamptzUtc.day);
      expect(storedTimestampUtc.hour, updatedTimestamptzUtc.hour);
      expect(storedTimestampUtc.minute, updatedTimestamptzUtc.minute);
      expect(storedTimestampUtc.second, updatedTimestamptzUtc.second);
      expect(storedTimestampUtc.millisecond, updatedTimestamptzUtc.millisecond);

      // Check if both timestamps are in UTC
      expect(storedTimestampUtc.isUtc, true);
      expect(updatedTimestamptzUtc.isUtc, true);

      // Compare the full DateTime objects
      expect(storedTimestampUtc, updatedTimestamptzUtc);
    }

    expect(readResult[0].col_timestamptz_array, isA<List<DateTime>>());
  });
}

Future<Object?> createTimestamptzArray(
    SupabaseClient supabase, List<DateTime> insertVal) async {
  try {
    await supabase.datetime_types.insert(DatetimeTypes.insert(
      id: uuidx,
      col_timestamptz_array: insertVal,
    ));
    return null;
  } catch (error) {
    return error;
  }
}

Future<List<DatetimeTypes>?> readTimestamptzArray(
    SupabaseClient supabase) async {
  try {
    var res = await supabase.datetime_types
        .select()
        .withConverter((data) => data.map(DatetimeTypes.fromJson).toList());
    return res;
  } catch (error) {
    print("readTimestamptzArr error");
    print(error);
    return null;
  }
}

Future<Object?> updateTimestamptzArray(SupabaseClient supabase,
    List<DateTime> oldValue, List<DateTime> value) async {
  try {
    await supabase.datetime_types
        .update(DatetimeTypes.update(col_timestamptz_array: value))
        .eq(DatetimeTypes.c_id, uuidx);
    return null;
  } catch (error) {
    print("updateTimestamptzArr error");
    print(error);
    return error;
  }
}
