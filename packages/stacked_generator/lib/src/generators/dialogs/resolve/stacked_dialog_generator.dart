import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:stacked_core/stacked_core.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:stacked_generator/import_resolver.dart';

import '../generate/dialog_class_generator.dart';
import 'dialog_config_resolver.dart';

class StackedDialogGenerator extends GeneratorForAnnotation<StackedApp> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final dialogResolver = DialogConfigResolver();
    final libs = await buildStep.resolver.libraries.toList();
    final importResolver = ImportResolver(libs, element.source?.uri.path ?? '');

    final dialogConfig = await dialogResolver.resolve(
      annotation,
      importResolver,
    );

    return DialogClassGenerator(dialogConfig).generate();
  }
}
