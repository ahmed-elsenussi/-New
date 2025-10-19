import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';
import 'package:card_register/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App builds successfully', (WidgetTester tester) async {
    // Create a fake CameraDescription (single camera)
    final testCamera = CameraDescription(
      name: 'TestCamera',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 0,
    );

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(camera: testCamera));

    // Simple sanity check: MaterialApp exists (app built)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
