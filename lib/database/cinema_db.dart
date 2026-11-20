import 'package:path/path.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite/sqflite.dart';
import 'package:southsea_cinema/models/basket_item.dart';

class CinemaDatabase {
  CinemaDatabase._internal();

  Future<void> createBookingItemsTable(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS booking_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      booking_id INTEGER NOT NULL,
      movie_id TEXT NOT NULL,
      movie_title TEXT NOT NULL,
      screening_time TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      unit_price REAL NOT NULL,
      line_total REAL NOT NULL,
      FOREIGN KEY (booking_id)
        REFERENCES bookings (id)
        ON DELETE CASCADE
    )
  ''');
  
}
Future<void> _upgradeDB(
  Database db,
  int oldVersion,
  int newVersion,
) async {
  if (oldVersion < 2) {
    await createBookingItemsTable(db);
  }
}

  static final CinemaDatabase instance = CinemaDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    final Database? cachedDatabase = _database;

    if (cachedDatabase != null) {
      return cachedDatabase;
    }

    final Database db = await _initDB('cinema_data.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filePath = join(folder, fileName);

    final Database db = await openDatabase(
      filePath,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );

    return db;
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);
    await createBookingItemsTable(db);

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1003,
      'summary': '2 x Dracula',
      'total': 25.00,
      'date': '18/04/2026 12:45',
    });

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1002,
      'summary': '1 x Fast & Furious 6',
      'total': 12.50,
      'date': '02/03/2026 18:10',
    });

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1001,
      'summary': '1 x Dracula',
      'total': 12.50,
      'date': '11/01/2026 13:02',
    });
  }

  Future<int> insertBooking(Booking booking) async {
    final Database db = await database;
    final int id = await db.insert('bookings', booking.toMap());
    return id;
  }

  Future<int> insertBookingWithItems(
  Booking booking,
  List<BasketItem> items,
) async {
  final Database db = await database;

  return db.transaction<int>((txn) async {
    // Save the main booking first.
    final int bookingId = await txn.insert(
      'bookings',
      booking.toMap(),
    );

    // Save each item linked to that booking.
    for (final BasketItem item in items) {
      await txn.insert('booking_items', <String, Object?>{
        'booking_id': bookingId,
        'movie_id': item.movie.id,
        'movie_title': item.movie.title,
        'screening_time': item.movie.screeningTime,
        'quantity': item.quantity,
        'unit_price': item.movie.price,
        'line_total': item.totalPrice,
      });
    }

    return bookingId;
  });
}

Future<List<Booking>> getAllBookings() async {
  final Database db = await database;

  final List<Map<String, Object?>> records = await db.query(
    'bookings',
    orderBy: 'booking_number DESC',
  );

  final List<Booking> bookings = [];

  for (final Map<String, Object?> row in records) {
    bookings.add(Booking.fromMap(row));
  }

  return bookings;
}

Future<List<Map<String, Object?>>> getBookingItems(
  int bookingId,
) async {
  final Database db = await database;

  return db.query(
    'booking_items',
    where: 'booking_id = ?',
    whereArgs: [bookingId],
  );
}

  Future<int> getNextBookingNumber() async {
    final Database db = await database;

    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(booking_number) as max_num FROM bookings',
    );

    if (records.isEmpty) {
      return 1001;
    }

    final Object? maxValue = records[0]['max_num'];

    if (maxValue == null) {
      return 1001;
    }

    final int currentMax = maxValue as int;
    return currentMax + 1;
  }

  Future<void> close() async {
    final Database? cachedDatabase = _database;

    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
}
