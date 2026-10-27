import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Small secrets on the device: tokens, device id, app PIN hash.
abstract interface class SecureStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Keys used in [SecureStore].
abstract final class SecureKeys {
  static const session = 'session';
  static const deviceId = 'device_id';
  static const pinHash = 'pin_hash';
  static const pinSalt = 'pin_salt';

  /// `on`/`off`: the owner's answer to «اثر انگشت فعال شود؟».
  static const deviceUnlock = 'device_unlock';

  /// Owner preferences (kept on logout).
  static const settings = 'settings';
}

/// Android Keystore-backed storage (flutter_secure_storage).
class DeviceSecureStore implements SecureStore {
  const new([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// In-memory store for tests and previews.
class MemorySecureStore implements SecureStore {
  new([Map<String, String>? initial]) : values = {...?initial};

  final Map<String, String> values;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}
