import 'package:caspian_owner/features/more/data/users_repositories.dart';
import 'package:caspian_owner/features/more/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';

void main() {
  test('reads every account from /admin/users', () async {
    final server = FakeServer()
      ..on(
        'GET',
        '/admin/users',
        FakeServer.json([
          _user(1, 'مدیر', 'admin'),
          _user(2, 'انبار کاسپین', 'warehouse'),
          _user(3, 'مهدی کریمی', 'unassigned', approval: 'pending'),
          _user(4, 'رضا احمدی', 'owner', active: false),
          _user(5, '', 'owner', approval: 'rejected'),
        ]),
      );

    final users = await ApiUsersRepository(server.client(token: 't')).list();

    expect(users.map((u) => u.role), [
      UserRole.admin,
      UserRole.warehouse,
      UserRole.unassigned,
      UserRole.owner,
      UserRole.owner,
    ]);
    expect(users[2].approval, UserApproval.pending);
    expect(users[3].active, isFalse);
    expect(users[4].approval, UserApproval.rejected);
    // No name: the username is shown instead.
    expect(users[4].nameFa, 'm09120000005');
  });
}

Map<String, Object?> _user(
  int id,
  String name,
  String role, {
  String approval = 'approved',
  bool active = true,
}) => {
  'id': id,
  'username': 'm0912000000$id',
  'full_name': name,
  'role': role,
  'is_active': active,
  'must_change_password': false,
  'last_login_at': null,
  'created_at': '2026-10-21T08:00:00Z',
  'mobile': '0912000000$id',
  'approval_status': approval,
};
