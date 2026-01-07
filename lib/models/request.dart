enum ZVService { umzug, transport, entruempelung }
enum ZVStatus { neu, kontaktiert, angebot, bestaetigt, verloren }

enum ParkingDistance { short, medium, long } // <10m, 10-30m, >30m
enum PriceType { fixed, range, inspection } // Pauschal, Spanne, Besichtigung

class Request {
  // core
  final String id;
  final DateTime createdAt;

  ZVService service;
  ZVStatus status;

  // pricing
  PriceType? priceType;
  double estimateMin;
  double estimateMax;

  // contact
  String name;
  String phone;
  String email;

  // addresses
  String pickupAddress;
  String dropoffAddress;

  // ✅ additional stops
  List<String> extraStops;

  // default details (umzug/transport)
  int pickupFloor;
  int dropoffFloor;
  bool pickupElevator;
  bool dropoffElevator;

  double volumeM3;
  bool disassembly;
  bool packing;
  bool disposal;

  DateTime? date;
  String note;

  // premium house basics
  int homeSqm;
  int rooms;
  bool hasBasement;
  bool hasAttic;
  bool hasGarage;

  // inventory
  Map<String, int> inventory;

  // ---------------- ENTRÜMPELUNG ----------------
  String? entruType; // Keller, Garage, Wohnung...
  String? entruSize; // Klein/Mittel/Groß...
  List<String> entruItems; // Elektrogeräte, Sperrmüll...

  int entruFloor;
  bool entruElevator;
  ParkingDistance entruParking;

  bool entruDisassembly;
  bool entruHeavy;
  bool entruDirty;

  String? entruOther;
  String? entruNote;

  // ✅ NEW: Fotos (lokale Pfade)
  List<String> entruPhotoPaths;

  // ✅ NEW: Straßengenehmigung / Halteverbot
  bool? entruPermitNeeded;
  String entruPermitNote;

  Request({
    required this.id,
    required this.createdAt,
    required this.service,
    required this.status,

    this.priceType,
    this.estimateMin = 0,
    this.estimateMax = 0,

    this.name = '',
    this.phone = '',
    this.email = '',

    this.pickupAddress = '',
    this.dropoffAddress = '',
    List<String>? extraStops,

    this.pickupFloor = 0,
    this.dropoffFloor = 0,
    this.pickupElevator = true,
    this.dropoffElevator = true,

    this.volumeM3 = 0,
    this.disassembly = false,
    this.packing = false,
    this.disposal = false,

    this.date,
    this.note = '',

    this.homeSqm = 0,
    this.rooms = 0,
    this.hasBasement = false,
    this.hasAttic = false,
    this.hasGarage = false,

    Map<String, int>? inventory,

    // entru defaults
    this.entruType,
    this.entruSize,
    List<String>? entruItems,
    this.entruFloor = 0,
    this.entruElevator = true,
    this.entruParking = ParkingDistance.short,
    this.entruDisassembly = false,
    this.entruHeavy = false,
    this.entruDirty = false,
    this.entruOther,
    this.entruNote,

    // ✅ photos defaults
    List<String>? entruPhotoPaths,

    // permit defaults
    this.entruPermitNeeded,
    this.entruPermitNote = '',
  })  : inventory = inventory ?? <String, int>{},
        entruItems = entruItems ?? <String>[],
        extraStops = extraStops ?? <String>[],
        entruPhotoPaths = entruPhotoPaths ?? <String>[];

  static Request draft() {
    final now = DateTime.now();
    return Request(
      id: now.millisecondsSinceEpoch.toString(),
      createdAt: now,
      service: ZVService.umzug,
      status: ZVStatus.neu,
    );
  }
}
