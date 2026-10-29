import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/features/more/domain/app_user.dart';

/// `GET /admin/users` on Caspian Server (admins only), read-only.
class ApiUsersRepository implements UsersRepository {
  const new(this._client);

  final ApiClient _client;

  @override
  Future<List<AppUser>> list() async => [
    for (final json in ApiClient.asList(await _client.get('/admin/users')))
      user(ApiClient.asMap(json)),
  ];

  /// One `AdminUserOut`. Unknown roles count as «نقش تعیین نشده» and
  /// unknown approvals as approved, so nothing is hidden.
  static AppUser user(Map<String, Object?> json) => AppUser(
    id: '${json['id']}',
    nameFa: (json['full_name'] as String?)?.trim().isNotEmpty ?? false
        ? (json['full_name']! as String).trim()
        : '${json['username']}',
    role: switch (json['role']) {
      'owner' => UserRole.owner,
      'warehouse' => UserRole.warehouse,
      'admin' => UserRole.admin,
      _ => UserRole.unassigned,
    },
    active: json['is_active'] != false,
    approval: switch (json['approval_status']) {
      'pending' => UserApproval.pending,
      'rejected' => UserApproval.rejected,
      _ => UserApproval.approved,
    },
  );
}

/// The sample owners (mock mode).
class MockUsersRepository implements UsersRepository {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<List<AppUser>> list() => _backend.call(
    () => [
      for (final owner in _backend.owners)
        AppUser(
          id: owner.id,
          nameFa: owner.nameFa,
          role: owner.isAdmin ? UserRole.admin : UserRole.owner,
          active: true,
          approval: UserApproval.approved,
        ),
    ],
  );
}
